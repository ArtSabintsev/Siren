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

    /// MARK: - Public Interface

    /// The `SirenDelegate` variable, which should be set if you'd like to be notified of any of specific user interactions or API success/failures.
    /// Also set this variable if you'd like to use custom UI for presesnting the update notification.
    public weak var delegate: SirenDelegate?

    /// Determines the type of alert that should be shown.
    /// See the Siren.AlertType enum for full details.
    public var rules: Rules = .default {
        didSet {
            majorUpdateRules = rules
            minorUpdateRules = rules
            patchUpdateRules = rules
            revisionUpdateRules = rules
        }
    }

    /// Determines the type of alert that should be shown for major version updates: A.b.c
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var majorUpdateRules: Rules = .default

    /// Determines the type of alert that should be shown for minor version updates: a.B.c
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var minorUpdateRules: Rules = .default

    /// Determines the type of alert that should be shown for minor patch updates: a.b.C
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var patchUpdateRules: Rules = .default

    /// Determines the type of alert that should be shown for revision updates: a.b.c.D
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var revisionUpdateRules: Rules = .default

    private var settings: Settings

    /// Overrides all the Strings to which Siren defaults.
    /// Defaults to the values defined in `SirenAlertMessaging.Constants`
    private var alertConfiguration: AlertConfiguration

    /// The debug flag, which is disabled by default.
    /// When enabled, a stream of print() statements are logged to your console when a version check is performed.
    var debugEnabled: Bool

    /// Current installed version of your app.
    var currentInstalledVersion: String? = Bundle.version()

    /// The current version of your app that is available for download on the App Store
    var currentAppStoreVersion: String?

    /// The last Date that a version check was performed.
    var lastVersionCheckPerformedOnDate: Date?

    private var appID: Int?
    private lazy var alertViewIsVisible: Bool = false
    var alertController: UIAlertController?

    /// The `UIWindow` instance that presents the `SirenAlertViewController`.
    private var updaterWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = SirenViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        return window
    }

    /// Type of the available update
    lazy var updateType: Constants.UpdateType = .unknown

    public init(settings: Settings,
                rules: Rules,
                alertConfiguration: AlertConfiguration,
                debugEnabled: Bool = false) {
        lastVersionCheckPerformedOnDate = UserDefaults.storedVersionCheckDate
        self.settings = settings
        self.rules = rules
        self.alertConfiguration = alertConfiguration
        self.debugEnabled = debugEnabled
    }

    /// Checks the currently installed version of your app against the App Store.
    /// The default check is against the US App Store, but if your app is not listed in the US,
    /// you should set the `countryCode` property before calling this method. Please refer to the countryCode property for more information.
    ///
    /// - Parameters:
    ///   - checkType: The frequency in days in which you want a check to be performed. Please refer to the Siren.VersionCheckType enum for more details.
    public func checkVersion() {
        updateType = .unknown
        let frequency = rules.frequency

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
                guard let self = self else { return }
                self.processResults(withData: data, response: response, error: error)
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

        guard VersionParser.isAppStoreVersionNewer(installedVersion: currentInstalledVersion,
                                                   appStoreVersion: currentAppStoreVersion) else {
            delegate?.sirenLatestVersionInstalled()
            return postError(.noUpdateAvailable)
        }

        guard let currentVersionReleaseDate = model.results.first?.currentVersionReleaseDate,
            let daysSinceRelease = Date.days(since: currentVersionReleaseDate) else {
            return
        }

        guard daysSinceRelease >= rules.releaseFordDays else {
            let message = "Your app has been released for \(daysSinceRelease) days, but Siren cannot prompt the user until \(rules.releaseFordDays) days have passed."
             return printMessage(message)
        }

        showAlertIfCurrentAppStoreVersionNotSkipped()
    }

    func iTunesURLFromString() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        var items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.bundleID())]

        if let countryCode = settings.countryCode {
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
        updateType = VersionParser.parse(installedVersion: currentInstalledVersion, appStoreVersion: currentAppStoreVersion)
        rules = loadRulesForUpdateType()

        guard let previouslySkippedVersion = UserDefaults.storedSkippedVersion else {
            showAlert()
            return
        }

        if let currentAppStoreVersion = currentAppStoreVersion, currentAppStoreVersion != previouslySkippedVersion {
            showAlert()
        }
    }

    func showAlert() {
        UserDefaults.storedVersionCheckDate = Date()

        let localization = Localization(settings: settings, forCurrentAppStoreVersion: currentAppStoreVersion)
        let alertTitle = localization.alertTitle()
        let alertMessage = localization.alertMessage()

       alertController = UIAlertController(title: alertTitle,
                                           message: alertMessage,
                                           preferredStyle: .alert)

        if let alertControllerTintColor = alertConfiguration.tintColor {
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
            delegate?.sirenDidDetectNewVersionWithoutAlert(title: alertTitle,
                                                           message: alertMessage,
                                                           updateType: updateType)
        }

        if rules.alertType != .none && !alertViewIsVisible {
            alertController?.show(window: updaterWindow)
            alertViewIsVisible = true
            delegate?.sirenDidShowUpdateDialog(alertType: rules.alertType)
        }
    }

    func updateAlertAction() -> UIAlertAction {
        let localization = Localization(settings: settings, forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.updateButtonTitle(), style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.alertController?.hide(window: self.updaterWindow)
            self.launchAppStore()
            self.delegate?.sirenUserDidLaunchAppStore()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func nextTimeAlertAction() -> UIAlertAction {
        let localization = Localization(settings: settings, forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.nextTimeButtonTitle(), style: .default) { [weak self] _  in
            guard let self = self else { return }

            self.alertController?.hide(window: self.updaterWindow)
            self.delegate?.sirenUserDidCancel()
            self.alertViewIsVisible = false
            UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch = true
            return
        }

        return action
    }

    func skipAlertAction() -> UIAlertAction {
        let localization = Localization(settings: settings, forCurrentAppStoreVersion: currentAppStoreVersion)
        let action = UIAlertAction(title: localization.skipButtonTitle(), style: .default) { [weak self] _ in
            guard let self = self else { return }

            if let currentAppStoreVersion = self.currentAppStoreVersion {
                UserDefaults.storedSkippedVersion = currentAppStoreVersion
                UserDefaults.standard.synchronize()
            }

            self.alertController?.hide(window: self.updaterWindow)
            self.delegate?.sirenUserDidSkipVersion()
            self.alertViewIsVisible = false
            return
        }

        return action
    }
}
