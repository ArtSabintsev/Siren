//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// The Siren Class.
public final class Siren: NSObject {
    /// Return results or errors obtained from performing a version check with Siren.
    public typealias ResultsHandler = (Result<UpdateResults, KnownError>) -> Void

    /// The Siren singleton. The main point of entry to the Siren library.
    public static let shared = Siren()

    /// The manager that controls the App Store API that is
    /// used to fetch the latest version of the app.
    ///
    /// Defaults to the US App Store.
    public lazy var apiManager: APIManager = .default

    /// The manager that controls the update alert's string localization and tint color.
    ///
    /// Defaults the string's lange localization to the user's device localization.
    public lazy var presentationManager: PresentationManager = .default

    /// The manager that controls the type of alert that should be displayed
    /// and how often an alert should be displayed dpeneding on the type
    /// of update that is available relative to the installed version of the app
    /// (e.g., different rules for major, minor, patch and revision updated can be used).
    ///
    /// Defaults to performing a version check once a day with an alert that allows
    /// the user to skip updating the app until the next time the app becomes active or
    /// skipping the update all together until another version is released.
    public lazy var rulesManager: RulesManager = .default

    /// The current installed version of your app.
    lazy var currentInstalledVersion: String? = Bundle.version()

    /// The retained `NotificationCenter` observer that listens for `UIApplication.didBecomeActiveNotification` notifications.
    var applicationDidBecomeActiveObserver: NSObjectProtocol?

    /// The retained `NotificationCenter` observer that listens for `UIApplication.willResignActiveNotification` notifications.
    var applicationWillResignActiveObserver: NSObjectProtocol?

    /// The retained `NotificationCenter` observer that listens for `UIApplication.didEnterBackgroundNotification` notifications.
    var applicationDidEnterBackgroundObserver: NSObjectProtocol?

    /// The last date that an alert was presented to the user.
    private var alertPresentationDate: Date? = UserDefaults.alertPresentationDate

    /// The App Store's unique identifier for an app.
    private var appID: Int?

    /// The completion handler used to return the results or errors returned by Siren.
    private var resultsHandler: ResultsHandler?

    /// The deinitialization method that clears out all observers,
    deinit {
        presentationManager.cleanUp()
        removeForegroundObservers()
        removeBackgroundObservers()
    }
}

// MARK: - Public API Interface

public extension Siren {
    /// This method executes the Siren version checking and alert presentation flow.
    ///
    /// - Parameters:
    ///   - performCheck: Defines how the version check flow is entered. Defaults to `.onForeground`.
    ///   - handler: Returns the metadata around a successful version check and interaction with the update modal or it returns nil.
    func wail(performCheck: PerformCheck = .onForeground,
              completion handler: ResultsHandler? = nil) {
        resultsHandler = handler

        switch performCheck {
        case .onDemand:
            removeForegroundObservers()
            performVersionCheck()
        case .onForeground:
            addForegroundObservers()
        }

        // Add background app state change observers.
        addBackgroundObservers()
    }

    /// Launches the AppStore in two situations when the user clicked the `Update` button in the UIAlertController modal.
    ///
    /// This function is marked `public` as a convenience for those developers who decide to build a custom alert modal
    /// instead of using Siren's prebuilt update alert.
    func launchAppStore() {
        guard let appID = appID,
            let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else {
                resultsHandler?(.failure(.malformedURL))
                return
        }

        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Version Check and Alert Presentation Flow

private extension Siren {
    /// Initiates the unidirectional version checking flow.
    func performVersionCheck() {
        alertPresentationDate = UserDefaults.alertPresentationDate
        apiManager.performVersionCheckRequest { result in
            switch result {
            case .success(let apiModel):
                self.validate(apiModel: apiModel)
            case .failure(let error):
                self.resultsHandler?(.failure(error))
            }
        }
    }

    /// Validates the parsed and mapped iTunes Lookup Model
    /// to guarantee all the relevant data was returned before
    /// attempting to present an alert.
    ///
    /// - Parameter apiModel: The iTunes Lookup Model.
    func validate(apiModel: APIModel) {
        // Check if the latest version is compatible with current device's version of iOS.
        guard DataParser.isUpdateCompatibleWithDeviceOS(for: apiModel) else {
            resultsHandler?(.failure(.appStoreOSVersionUnsupported))
            return
        }

        // Check and store the App ID .
        guard let results = apiModel.results.first,
            let appID = apiModel.results.first?.appID else {
            resultsHandler?(.failure(.appStoreAppIDFailure))
            return
        }
        self.appID = appID

        // Check and store the current App Store version.
        guard let currentAppStoreVersion = apiModel.results.first?.version else {
            resultsHandler?(.failure(.appStoreVersionArrayFailure))
            return
        }

        // Check if the App Store version is newer than the currently installed version.
        guard DataParser.isAppStoreVersionNewer(installedVersion: currentInstalledVersion,
                                                appStoreVersion: currentAppStoreVersion) else {
            resultsHandler?(.failure(.noUpdateAvailable))
            return
        }

        // Check the release date of the current version.
        guard let currentVersionReleaseDate = apiModel.results.first?.currentVersionReleaseDate,
            let daysSinceRelease = Date.days(since: currentVersionReleaseDate) else {
                resultsHandler?(.failure(.currentVersionReleaseDate))
                return
        }

        // Check if applicaiton has been released for the amount of days defined by the app consuming Siren.
        guard daysSinceRelease >= rulesManager.releasedForDays else {
            resultsHandler?(.failure(.releasedTooSoon(daysSinceRelease: daysSinceRelease,
                                                      releasedForDays: rulesManager.releasedForDays)))
            return
        }

        let model = Model(appID: appID,
                          currentVersionReleaseDate: currentVersionReleaseDate,
                          minimumOSVersion: results.minimumOSVersion,
                          releaseNotes: results.releaseNotes,
                          version: results.version)

        determineIfAlertPresentationRulesAreSatisfied(forCurrentAppStoreVersion: currentAppStoreVersion, andModel: model)
    }

    /// Determines if the update alert can be presented based on the
    /// rules set in the `RulesManager` and the the skip version settings.
    ///
    /// - Parameters:
    ///   - currentAppStoreVersion: The curren version of the app in the App Store.
    ///   - model: The iTunes Lookup Model.
    func determineIfAlertPresentationRulesAreSatisfied(forCurrentAppStoreVersion currentAppStoreVersion: String, andModel model: Model) {
        // Did the user:
        // - request to skip being prompted with version update alerts for a specific version
        // - and is the latest App Store update the same version that was requested?
        if let previouslySkippedVersion = UserDefaults.storedSkippedVersion,
            let currentInstalledVersion = currentInstalledVersion,
            !currentAppStoreVersion.isEmpty,
            currentAppStoreVersion == previouslySkippedVersion {
            resultsHandler?(.failure(.skipVersionUpdate(installedVersion: currentInstalledVersion,
                                                        appStoreVersion: currentAppStoreVersion)))
                return
        }

        let updateType = DataParser.parseForUpdate(forInstalledVersion: currentInstalledVersion,
                                                   andAppStoreVersion: currentAppStoreVersion)
        do {
            let rules = try rulesManager.loadRulesForUpdateType(updateType)

            if rules.frequency == .immediately {
                presentAlert(withRules: rules, forCurrentAppStoreVersion: currentAppStoreVersion, model: model, andUpdateType: updateType)
            } else {
                guard let alertPresentationDate = alertPresentationDate else {
                    presentAlert(withRules: rules, forCurrentAppStoreVersion: currentAppStoreVersion, model: model, andUpdateType: updateType)
                    return
                }
                if Date.days(since: alertPresentationDate) >= rules.frequency.rawValue {
                    presentAlert(withRules: rules, forCurrentAppStoreVersion: currentAppStoreVersion, model: model, andUpdateType: updateType)
                } else {
                    resultsHandler?(.failure(.recentlyPrompted))
                }
            }
        } catch let error as KnownError {
            resultsHandler?(.failure(error))
        } catch { // This path should never be entered, but this silences an error.
            resultsHandler?(.failure(.noUpdateAvailable))
        }
    }

    /// Presents the update alert to the end user.
    /// Upon tapping a value on the alert view, a completion handler will return all relevant metadata to the app.
    ///
    /// - Parameters:
    ///   - rules: The rules for how to present the alert.
    ///   - currentAppStoreVersion: The current version of the app in the App Store.
    ///   - model: The iTunes Lookup Model.
    ///   - updateType: The type of update that is available based on the version found in the App Store.
    func presentAlert(withRules rules: Rules,
                      forCurrentAppStoreVersion currentAppStoreVersion: String,
                      model: Model,
                      andUpdateType updateType: RulesManager.UpdateType) {
        presentationManager.presentAlert(withRules: rules, forCurrentAppStoreVersion: currentAppStoreVersion) { [weak self] alertAction, currentAppStoreVersion in
            guard let self = self else { return }
            self.processAlertAction(alertAction: alertAction, currentAppStoreVersion: currentAppStoreVersion)

            let results = UpdateResults(alertAction: alertAction,
                                  localization: self.presentationManager.localization,
                                  model: model,
                                  updateType: updateType)
            self.resultsHandler?(.success(results))
        }
    }

    func processAlertAction(alertAction: AlertAction, currentAppStoreVersion: String?) {
        switch alertAction {
        case .appStore:
            launchAppStore()
        case .skip:
            guard let currentAppStoreVersion = currentAppStoreVersion else { return }
            UserDefaults.storedSkippedVersion = currentAppStoreVersion
            UserDefaults.standard.synchronize()
        default:
            break
        }
    }
}

// MARK: - Add Observers

private extension Siren {
    /// Adds an observer that listens for app launching/relaunching.
    func addForegroundObservers() {
        guard applicationDidBecomeActiveObserver == nil else { return }
        applicationDidBecomeActiveObserver = NotificationCenter
            .default
            .addObserver(forName: UIApplication.didBecomeActiveNotification,
                         object: nil,
                         queue: nil) { [weak self] _ in
                            guard let self = self else { return }
                            self.performVersionCheck()
        }
    }

    /// Adds an observer that listens for when the user enters the app switcher
    /// and when the app is sent to the background.
    func addBackgroundObservers() {
        if applicationWillResignActiveObserver == nil {
            applicationWillResignActiveObserver = NotificationCenter
                .default
                .addObserver(forName: UIApplication.willResignActiveNotification,
                             object: nil,
                             queue: nil) { [weak self] _ in
                                guard let self = self else { return }
                                self.presentationManager.cleanUp()
            }
        }

        if applicationDidEnterBackgroundObserver == nil {
            applicationDidEnterBackgroundObserver = NotificationCenter
                .default
                .addObserver(forName: UIApplication.didEnterBackgroundNotification,
                             object: nil,
                             queue: nil) { [weak self] _ in
                                guard let self = self else { return }
                                self.presentationManager.cleanUp()
            }
        }
    }
}

// MARK: - Remove Observers

private extension Siren {
    /// Removes the observer that listens for app launching/relaunching.
    func removeForegroundObservers() {
        NotificationCenter.default.removeObserver(applicationDidBecomeActiveObserver as Any)
        applicationDidBecomeActiveObserver = nil
    }

    /// Remove the observers that list to app resignation and app backgrounding.
    func removeBackgroundObservers() {
        NotificationCenter.default.removeObserver(applicationWillResignActiveObserver as Any)
        applicationWillResignActiveObserver = nil

        NotificationCenter.default.removeObserver(applicationDidEnterBackgroundObserver as Any)
        applicationDidEnterBackgroundObserver = nil
    }
}
