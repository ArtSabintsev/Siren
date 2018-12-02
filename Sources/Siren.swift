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
    /// The `SirenDelegate` variable, which should be set if you'd like to be notified of any of specific user interactions or API success/failures.
    /// Also set this variable if you'd like to use custom UI for presesnting the update notification.
    public weak var delegate: SirenDelegate?

    private var settings: Settings

    private var rulesManager: RulesManager

    private var alertConfiguration: AlertConfiguration

    /// The debug flag, which is disabled by default.
    /// When enabled, a stream of `print()` statements are logged to your console when a version check is performed.
    var debugEnabled: Bool

    /// Current installed version of your app.
    lazy var currentInstalledVersion: String? = Bundle.version()

    /// The current version of your app that is available for download on the App Store
    var currentAppStoreVersion: String?

    /// The last date that a version check was performed.
    private var lastVersionCheckPerformedOnDate: Date?

    private var appID: Int?
    private lazy var alertViewIsVisible: Bool = false
    var alertController: UIAlertController?

    /// The `UIWindow` instance that presents the `SirenViewController`.
    private var updaterWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = SirenViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        return window
    }

    public init(settings: Settings = .default,
                rulesManager: RulesManager = .default,
                alertConfiguration: AlertConfiguration = .default,
                debugEnabled: Bool = false) {
        lastVersionCheckPerformedOnDate = UserDefaults.storedVersionCheckDate
        self.settings = settings
        self.rulesManager = rulesManager
        self.alertConfiguration = alertConfiguration
        self.debugEnabled = debugEnabled
    }

    /// Checks the currently installed version of your app against the App Store.
    /// The default check is against the US App Store, but if your app is not listed in the US,
    /// you should set the `countryCode` property before calling this method. Please refer to the countryCode property for more information.
    ///
    /// - Parameters:
    ///   - checkType: The frequency in days in which you want a check to be performed. Please refer to the Siren.VersionCheckType enum for more details.
    public func wail() {
        guard Bundle.bundleID() != nil else {
            printMessage("Please make sure that you have set a `Bundle Identifier` in your project.")
            return
        }

        performVersionCheckRequest()
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
    func performVersionCheckRequest() {
        do {
            let url = try makeITunesURL(fromSettings: settings)
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                self.processVersionCheckResults(withData: data, response: response, error: error)
            }.resume()
        } catch {
            postError(.malformedURL)
        }
    }

    func processVersionCheckResults(withData data: Data?, response: URLResponse?, error: Error?) {
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
        // Check if the latest version is compatible with current device's version of iOS.
        guard isUpdateCompatibleWithDeviceOS(for: model) else { return }

        // Check and store the appID .
        guard let appID = model.results.first?.appID else {
            return postError(.appStoreAppIDFailure)
        }

        self.appID = appID

        // Check and store the current App Store version.
        guard let currentAppStoreVersion = model.results.first?.version else {
            return postError(.appStoreVersionArrayFailure)
        }

        self.currentAppStoreVersion = currentAppStoreVersion

        // Check if the App Store version is newer than the currently installed version.
        guard VersionParser.isAppStoreVersionNewer(installedVersion: currentInstalledVersion, appStoreVersion: currentAppStoreVersion) else {
            delegate?.sirenLatestVersionInstalled()
            return postError(.noUpdateAvailable)
        }

        // Check the release date of the current version.
        guard let currentVersionReleaseDate = model.results.first?.currentVersionReleaseDate,
            let daysSinceRelease = Date.days(since: currentVersionReleaseDate) else {
            return
        }

        // Check if applicaiton has been released for the
        // amount of daysdefined by the app consuming Siren.
        guard daysSinceRelease >= rulesManager.releasedForDays else {
            let message = "Your app has been released for \(daysSinceRelease) days, but Siren cannot prompt the user until \(rulesManager.releasedForDays) days have passed."
             return printMessage(message)
        }

        determineIfAlertPresentationRulesAreSatisfied()
    }
}

// MARK: - Alert Presentation

private extension Siren {
    func determineIfAlertPresentationRulesAreSatisfied() {
        // Determine the set of alert presentation rules based on the type of version update.
        let updateType = VersionParser.parse(installedVersion: currentInstalledVersion, appStoreVersion: currentAppStoreVersion)
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
                postError(.recentlyCheckedAlready)
            }
        }
    }

    func showAlert(withRules rules: Rules) {
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
                                                           updateType: RulesManager.UpdateType.unknown)
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
