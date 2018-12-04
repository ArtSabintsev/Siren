//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// The Siren Class. A singleton that is initialized using the `shared` constant.
public final class Siren: NSObject {

    /// An `Either` type used to return results or errors obtained from checking a version with Siren.
    public typealias CompletionHandler = (Results?, KnownError?) -> Void

    /// The Siren singleton. The main point of entry to the Siren library.
    public static let shared = Siren()

    public lazy var presentationManager: PresentationManager = .default

    public lazy var apiManager: APIManager = .default

    public lazy var rulesManager: RulesManager = .default

    /// The debug flag, which is disabled by default.
    /// When enabled, a stream of `print()` statements are logged to your console when a version check is performed.
    public lazy var debugEnabled: Bool = false

    /// Current installed version of your app.
    internal lazy var currentInstalledVersion: String? = Bundle.version()

    /// The current version of your app that is available for download on the App Store
    internal var currentAppStoreVersion: String?

    /// The retained `NotificationCenter` observer that listens for `UIApplication.didBecomeActiveNotification` notifications.
    internal var didBecomeActiveObserver: NSObjectProtocol?

    /// The completion handler used to return the results or errors returned by Siren.
    private var completionHandler: CompletionHandler?

    /// The Swift model representation of API results from the iTunes Lookup API.
    private var lookupModel: LookupModel?

    /// The instance of the `UIAlertController` used to present the update alert.
    private var alertController: UIAlertController?

    /// The last date that a version check was performed.
    private var lastVersionCheckPerformedOnDate: Date?

    /// The App Store's unique identifier for an app.
    private var appID: Int?

    private lazy var updateType: RulesManager.UpdateType = .unknown

    private lazy var alertViewIsVisible: Bool = false

    /// The `UIWindow` instance that presents the `SirenViewController`.
    private var updaterWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = SirenViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        return window
    }

    private override init() {
        lastVersionCheckPerformedOnDate = UserDefaults.storedVersionCheckDate
    }
}

// MARK: - Public Functionality

public extension Siren {
    func start(completion handler: CompletionHandler?) {
        completionHandler = handler
        addObservers()
    }

    /// Launches the AppStore in two situations:
    ///
    /// - User clicked the `Update` button in the UIAlertController modal.
    /// - Developer built a custom alert modal and needs to be able to call this function when the user chooses to update the app in the aforementioned custom modal.
    func launchAppStore() {
        guard let appID = appID,
            let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else {
                return
        }

        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: - Networking

extension Siren {
    func performVersionCheckRequest() {
        updateType = .unknown

        guard Bundle.bundleID() != nil else {
            completionHandler?(nil, .missingBundleID)
            return
        }

        do {
            let url = try makeITunesURL(fromAPIManager: apiManager)
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                self.processVersionCheckResults(withData: data, response: response, error: error)
            }.resume()
        } catch {
            completionHandler?(nil, .malformedURL)
        }
    }

    private func processVersionCheckResults(withData data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            completionHandler?(nil, .appStoreDataRetrievalFailure(underlyingError: error))
        } else {
            guard let data = data else {
               completionHandler?(nil, .appStoreDataRetrievalFailure(underlyingError: nil))
                return
            }
            do {
                let lookupModel = try JSONDecoder().decode(LookupModel.self, from: data)
                self.lookupModel = lookupModel

                guard !lookupModel.results.isEmpty else {
                    completionHandler?(nil, .appStoreDataRetrievalEmptyResults)
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.analyze(model: lookupModel)
                }
            } catch {
                completionHandler?(nil, .appStoreJSONParsingFailure(underlyingError: error))
            }
        }
    }

    private func analyze(model: LookupModel) {
        // Check if the latest version is compatible with current device's version of iOS.
        guard isUpdateCompatibleWithDeviceOS(for: model) else {
            completionHandler?(nil, .appStoreOSVersionUnsupported)
            return
        }

        // Check and store the App ID .
        guard let appID = model.results.first?.appID else {
            completionHandler?(nil, .appStoreAppIDFailure)
            return
        }
        self.appID = appID

        // Check and store the current App Store version.
        guard let currentAppStoreVersion = model.results.first?.version else {
            completionHandler?(nil, .appStoreVersionArrayFailure)
            return
        }
        self.currentAppStoreVersion = currentAppStoreVersion

        // Check if the App Store version is newer than the currently installed version.
        guard VersionParser.isAppStoreVersionNewer(installedVersion: currentInstalledVersion, appStoreVersion: currentAppStoreVersion) else {
            completionHandler?(nil, .noUpdateAvailable)
            return
        }

        // Check the release date of the current version.
        guard let currentVersionReleaseDate = model.results.first?.currentVersionReleaseDate,
            let daysSinceRelease = Date.days(since: currentVersionReleaseDate) else {
                completionHandler?(nil, .currentVersionReleaseDate)
                return
        }

        // Check if applicaiton has been released for the amount of days defined by the app consuming Siren.
        guard daysSinceRelease >= rulesManager.releasedForDays else {
            completionHandler?(nil, .releasedTooSoon(daysSinceRelease: daysSinceRelease,
                                                     releasedForDays: rulesManager.releasedForDays))
            return
        }

        determineIfAlertPresentationRulesAreSatisfied()
    }
}

// MARK: - Alert Presentation

private extension Siren {
    func determineIfAlertPresentationRulesAreSatisfied() {
        // Determine the set of alert presentation rules based on the type of version update.
        updateType = VersionParser.parse(installedVersion: currentInstalledVersion, appStoreVersion: currentAppStoreVersion)
        let rules = rulesManager.loadRulesForUpdateType(updateType)

        // Did the user:
        // - request to skip being prompted with version update alerts for a specific version
        // - and is the latest App Store update the same version that was requested?
        if let previouslySkippedVersion = UserDefaults.storedSkippedVersion,
            let currentAppStoreVersion = currentAppStoreVersion,
            currentAppStoreVersion != previouslySkippedVersion {
                return
        }

        if rules.frequency == .immediately {
            showAlert(withRules: rules)
        } else if UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch {
            UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch = false
            showAlert(withRules: rules)
        } else {
            guard let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate else {
                showAlert(withRules: rules)
                return
            }

            if Date.days(since: lastVersionCheckPerformedOnDate) >= rules.frequency.rawValue {
                showAlert(withRules: rules)
            } else {
                completionHandler?(nil, .recentlyCheckedVersion)
            }
        }
    }

    func showAlert(withRules rules: Rules) {
        UserDefaults.storedVersionCheckDate = Date()

        let localization = Localization(presentationManager: presentationManager, forCurrentAppStoreVersion: currentAppStoreVersion)
        let alertTitle = localization.alertTitle()
        let alertMessage = localization.alertMessage()

       alertController = UIAlertController(title: alertTitle,
                                           message: alertMessage,
                                           preferredStyle: .alert)

        if let alertControllerTintColor = presentationManager.tintColor {
            alertController?.view.tintColor = alertControllerTintColor
        }

        switch rules.alertType {
        case .force:
            alertController?.addAction(updateAlertAction())
        case .option:
            alertController?.addAction(nextTimeAlertAction())
            alertController?.addAction(updateAlertAction())
        case .skip:
            alertController?.addAction(nextTimeAlertAction())
            alertController?.addAction(updateAlertAction())
            alertController?.addAction(skipAlertAction())
        case .none:
            let results = Results(alertAction: .unknown,
                                  localization: localization,
                                  lookupModel: lookupModel,
                                  updateType: updateType)
            completionHandler?(results, nil)
        }

        if rules.alertType != .none && !alertViewIsVisible {
            alertController?.show(window: updaterWindow)
            alertViewIsVisible = true
        }
    }

    func updateAlertAction() -> UIAlertAction {
        let localization = Localization(presentationManager: presentationManager, forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.updateButtonTitle(), style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.alertController?.hide(window: self.updaterWindow)
            self.launchAppStore()
            self.alertViewIsVisible = false

            let results = Results(alertAction: .appStore,
                                  localization: localization,
                                  lookupModel: self.lookupModel,
                                  updateType: self.updateType)
            self.completionHandler?(results, nil)
            return
        }

        return action
    }

    func nextTimeAlertAction() -> UIAlertAction {
        let localization = Localization(presentationManager: presentationManager, forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.nextTimeButtonTitle(), style: .default) { [weak self] _  in
            guard let self = self else { return }

            self.alertController?.hide(window: self.updaterWindow)
            self.alertViewIsVisible = false
            UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch = true

            let results = Results(alertAction: .cancel,
                                  localization: localization,
                                  lookupModel: self.lookupModel,
                                  updateType: self.updateType)
            self.completionHandler?(results, nil)
            return
        }

        return action
    }

    func skipAlertAction() -> UIAlertAction {
        let localization = Localization(presentationManager: presentationManager, forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.skipButtonTitle(), style: .default) { [weak self] _ in
            guard let self = self else { return }

            if let currentAppStoreVersion = self.currentAppStoreVersion {
                UserDefaults.storedSkippedVersion = currentAppStoreVersion
                UserDefaults.standard.synchronize()
            }

            self.alertController?.hide(window: self.updaterWindow)
            self.alertViewIsVisible = false

            let results = Results(alertAction: .skip,
                                  localization: localization,
                                  lookupModel: self.lookupModel,
                                  updateType: self.updateType)
            self.completionHandler?(results, nil)
            return
        }

        return action
    }
}

// MARK: - Helpers

private extension Siren {
    func addObservers() {
        guard didBecomeActiveObserver == nil else { return }
        didBecomeActiveObserver = NotificationCenter
            .default
            .addObserver(forName: UIApplication.didBecomeActiveNotification,
                         object: nil,
                         queue: nil) { [weak self] _ in
                            guard let self = self else { return }
                            self.performVersionCheckRequest()
        }
    }

    func makeITunesURL(fromAPIManager apiManager: APIManager) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        var items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.bundleID())]

        if let countryCode = apiManager.countryCode {
            let item = URLQueryItem(name: "country", value: countryCode)
            items.append(item)
        }

        components.queryItems = items

        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw KnownError.malformedURL
        }

        return url
    }

    func isUpdateCompatibleWithDeviceOS(for model: LookupModel) -> Bool {
        guard let requiredOSVersion = model.results.first?.minimumOSVersion else {
            return false
        }

        let systemVersion = UIDevice.current.systemVersion

        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame else {
                return false
        }

        return true
    }
}
