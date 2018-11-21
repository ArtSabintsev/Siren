//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

// MARK: - Siren

/// The Siren Class. A singleton that is initialized using the `shared` constant.
public final class Siren: NSObject {

    /// Current installed version of your app.
    internal var currentInstalledVersion: String? = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }()

    /// The `SirenDelegate` variable, which should be set if you'd like to be notified of any of specific user interactions or API success/failures.
    /// Also set this variable if you'd like to use custom UI for presesnting the update notification.
    public weak var delegate: SirenDelegate?

    /// The debug flag, which is disabled by default.
    /// When enabled, a stream of print() statements are logged to your console when a version check is performed.
    public lazy var debugEnabled = false

    /// Determines the type of alert that should be shown.
    /// See the Siren.AlertType enum for full details.
    public var configuration: Configuration = .default {
        didSet {
            majorUpdateConfiguration = configuration
            minorUpdateConfiguration = configuration
            patchUpdateConfiguration = configuration
            revisionUpdateConfiguration = configuration
        }
    }

    /// Determines the type of alert that should be shown for major version updates: A.b.c
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var majorUpdateConfiguration: Configuration = .default

    /// Determines the type of alert that should be shown for minor version updates: a.B.c
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var minorUpdateConfiguration: Configuration = .default

    /// Determines the type of alert that should be shown for minor patch updates: a.b.C
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var patchUpdateConfiguration: Configuration = .default

    /// Determines the type of alert that should be shown for revision updates: a.b.c.D
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var revisionUpdateConfiguration: Configuration = .default

    /// The name of your app.
    /// By default, it's set to the name of the app that's stored in your plist.
    public lazy var appName = Bundle.bestMatchingAppName()

    /// Overrides all the Strings to which Siren defaults.
    /// Defaults to the values defined in `SirenAlertMessaging.Constants`
    public var alertMessaging = AlertMessaging()

    /// The region or country of an App Store in which your app is available.
    /// By default, all version checks are performed against the US App Store.
    /// If your app is not available in the US App Store, set it to the identifier of at least one App Store within which it is available.
    public var countryCode: String?

    /// Overrides the default localization of a user's device when presenting the update message and button titles in the alert.
    /// See the Siren.LanguageType enum for more details.
    public var forceLanguageLocalization: Localization.Language?

    /// Overrides the tint color for UIAlertController.
    public var alertControllerTintColor: UIColor?

    /// When this is set, the alert will only show up if the current version has already been released for X days.
    /// Defaults to 1 day to avoid an issue where Apple updates the JSON faster than the app binary propogates to the App Store.
    public lazy var showAlertAfterCurrentVersionHasBeenReleasedForDays: Int = 1

    /// The current version of your app that is available for download on the App Store
    public internal(set) var currentAppStoreVersion: String?

    /// The `UIWindow` instance that presents the `SirenAlertViewController`.
    var updaterWindow: UIWindow?

    /// The last Date that a version check was performed.
    var lastVersionCheckPerformedOnDate: Date?

    private var appID: Int?
    private lazy var alertViewIsVisible: Bool = false

    /// Type of the available update
    private lazy var updateType: Constants.UpdateType = .unknown

    /// The error domain for all errors created by Siren.
    private let SirenErrorDomain = "Siren Error Domain"

    /// The App's Singleton
    public static let shared = Siren(withConfiguration: .default)

    init(withConfiguration configuration: Configuration) {
        lastVersionCheckPerformedOnDate = UserDefaults.storedVersionCheckDate
        self.configuration = configuration
    }

    /// Checks the currently installed version of your app against the App Store.
    /// The default check is against the US App Store, but if your app is not listed in the US,
    /// you should set the `countryCode` property before calling this method. Please refer to the countryCode property for more information.
    ///
    /// - Parameters:
    ///   - checkType: The frequency in days in which you want a check to be performed. Please refer to the Siren.VersionCheckType enum for more details.
    public func checkVersion() {
        updateType = .unknown
        let frequency = configuration.frequency

        guard Bundle.bundleID() != nil else {
            printMessage("Please make sure that you have set a `Bundle Identifier` in your project.")
            return
        }

        if frequency == .immediately {
            performVersionCheck()
        } else if UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch {
            UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch = false
            performVersionCheck()
        } else {
            guard let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate else {
                performVersionCheck()
                return
            }

            if Date.days(since: lastVersionCheckPerformedOnDate) >= frequency.rawValue {
                performVersionCheck()
            } else {
                postError(.recentlyCheckedAlready)
            }
        }
    }

    /// Launches the AppStore in two situations:
    /// 
    /// - User clicked the `Update` button in the UIAlertController modal.
    /// - Developer built a custom alert modal and needs to be able to call this function when the user chooses to update the app in the aforementioned custom modal.
    public func launchAppStore() {
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

private extension Siren {
    func performVersionCheck() {
        do {
            let url = try iTunesURLFromString()
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                self?.processResults(withData: data, response: response, error: error)
            }.resume()
        } catch {
            postError(.malformedURL)
        }
    }

    func processResults(withData data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            postError(.appStoreDataRetrievalFailure(underlyingError: error))
        } else {
            guard let data = data else {
                return postError(.appStoreDataRetrievalFailure(underlyingError: nil))
            }
            do {
                let decodedData = try JSONDecoder().decode(LookupModel.self, from: data)

                guard !decodedData.results.isEmpty else {
                    return postError(.appStoreDataRetrievalEmptyResults)
                }

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.printMessage("Decoded JSON results: \(decodedData)")
                    self.delegate?.sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: decodedData)
                    self.processVersionCheck(with: decodedData)
                }
            } catch {
                postError(.appStoreJSONParsingFailure(underlyingError: error))
            }
        }
    }

    func processVersionCheck(with model: LookupModel) {
        guard isUpdateCompatibleWithDeviceOS(for: model) else { return }

        guard let appID = model.results.first?.appID else {
            return postError(.appStoreAppIDFailure)
        }

        self.appID = appID

        guard let currentAppStoreVersion = model.results.first?.version else {
            return postError(.appStoreVersionArrayFailure)
        }

        self.currentAppStoreVersion = currentAppStoreVersion

        guard isAppStoreVersionNewer() else {
            delegate?.sirenLatestVersionInstalled()
            return postError(.noUpdateAvailable)
        }

        guard let currentVersionReleaseDate = model.results.first?.currentVersionReleaseDate,
            let daysSinceRelease = Date.days(since: currentVersionReleaseDate) else {
            return
        }

        guard daysSinceRelease >= showAlertAfterCurrentVersionHasBeenReleasedForDays else {
            let message = "Your app has been released for \(daysSinceRelease) days, but Siren cannot prompt the user until \(showAlertAfterCurrentVersionHasBeenReleasedForDays) days have passed."
            printMessage(message)
            return
        }

        showAlertIfCurrentAppStoreVersionNotSkipped()
    }

    func iTunesURLFromString() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        var items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.bundleID())]

        if let countryCode = countryCode {
            let item = URLQueryItem(name: "country", value: countryCode)
            items.append(item)
        }

        components.queryItems = items

        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw CapturedError.Known.malformedURL
        }

        return url
    }
}

// MARK: - Alert

private extension Siren {
    func showAlertIfCurrentAppStoreVersionNotSkipped() {
        configuration = loadProperConfiguration()

        guard let previouslySkippedVersion = UserDefaults.storedSkippedVersion else {
            showAlert()
            return
        }

        if let currentAppStoreVersion = currentAppStoreVersion, currentAppStoreVersion != previouslySkippedVersion {
            showAlert()
        }
    }

    func showAlert() {
        storeVersionCheckDate()

        let localization = Localization(forceLanguageLocalization: forceLanguageLocalization,
                                        forAppName: appName,
                                        forCurrentAppStoreVersion: currentAppStoreVersion)

        let alertTitle = localization.alertTitle()
        let alertMessage = localization.alertMessage()

        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)

        if let alertControllerTintColor = alertControllerTintColor {
            alertController.view.tintColor = alertControllerTintColor
        }

        switch configuration.alertType {
        case .force:
            alertController.addAction(updateAlertAction())
        case .option:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
        case .skip:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
            alertController.addAction(skipAlertAction())
        case .none:
            delegate?.sirenDidDetectNewVersionWithoutAlert(title: alertTitle,
                                                           message: alertMessage,
                                                           updateType: updateType)
        }

        if configuration.alertType != .none && !alertViewIsVisible {
            alertController.show()
            alertViewIsVisible = true
            delegate?.sirenDidShowUpdateDialog(alertType: configuration.alertType)
        }
    }

    func updateAlertAction() -> UIAlertAction {
        let localization = Localization(forceLanguageLocalization: forceLanguageLocalization,
                                        forAppName: appName,
                                        forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.updateButtonTitle(), style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.hideWindow()
            self.launchAppStore()
            self.delegate?.sirenUserDidLaunchAppStore()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func nextTimeAlertAction() -> UIAlertAction {
        let localization = Localization(forceLanguageLocalization: forceLanguageLocalization,
                                        forAppName: appName,
                                        forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.nextTimeButtonTitle(), style: .default) { [weak self] _  in
            guard let self = self else { return }

            self.hideWindow()
            self.delegate?.sirenUserDidCancel()
            self.alertViewIsVisible = false
            UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch = true
            return
        }

        return action
    }

    func skipAlertAction() -> UIAlertAction {
        let localization = Localization(forceLanguageLocalization: forceLanguageLocalization,
                                        forAppName: appName,
                                        forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.skipButtonTitle(), style: .default) { [weak self] _ in
            guard let self = self else { return }

            if let currentAppStoreVersion = self.currentAppStoreVersion {
                UserDefaults.storedSkippedVersion = currentAppStoreVersion
                UserDefaults.standard.synchronize()
            }

            self.hideWindow()
            self.delegate?.sirenUserDidSkipVersion()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func loadProperConfiguration() -> Configuration {
        var configuration: Configuration = .default

        guard let currentInstalledVersion = currentInstalledVersion,
            let currentAppStoreVersion = currentAppStoreVersion else {
                return configuration
        }

        let oldVersion = versionParser(for: currentInstalledVersion)
        let newVersion = versionParser(for: currentAppStoreVersion)

        guard let newVersionFirst = newVersion.first, let oldVersionFirst = oldVersion.first else {
            return configuration
        }

        if newVersionFirst > oldVersionFirst { // A.b.c.d
            configuration = majorUpdateConfiguration
            updateType = .major
        } else if newVersion.count > 1 && (oldVersion.count <= 1 || newVersion[1] > oldVersion[1]) { // a.B.c.d
            configuration = minorUpdateConfiguration
            updateType = .minor
        } else if newVersion.count > 2 && (oldVersion.count <= 2 || newVersion[2] > oldVersion[2]) { // a.b.C.d
            configuration = patchUpdateConfiguration
            updateType = .patch
        } else if newVersion.count > 3 && (oldVersion.count <= 3 || newVersion[3] > oldVersion[3]) { // a.b.c.D
            configuration = revisionUpdateConfiguration
            updateType = .revision
        }

        return configuration
    }
}
