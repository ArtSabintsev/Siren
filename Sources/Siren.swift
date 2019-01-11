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
    public typealias ResultsHandler = (Results?, KnownError?) -> Void

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
    var didBecomeActiveObserver: NSObjectProtocol?

    /// The retained `NotificationCenter` observer that listens for `UIApplication.didEnterBackgroundNotification` notifications.
    var didEnterBackgroundObserver: NSObjectProtocol?

    /// The last date that an alert was presented to the user.
    private var alertPresentationDate: Date?

    /// The App Store's unique identifier for an app.
    private var appID: Int?

    /// The completion handler used to return the results or errors returned by Siren.
    private var resultsHandler: ResultsHandler?

    /// The initialization method.
    private override init() {
        alertPresentationDate = UserDefaults.alertPresentationDate
    }
}

// MARK: - Public API Interface

public extension Siren {
    /// This method executes the Siren version checking and alert presentation flow.
    ///
    /// - Parameter handler: Returns the metadata around a successful version check and interaction with the update modal or it returns nil.
    func wail(completion handler: ResultsHandler? = nil) {
        resultsHandler = handler
        addObservers()
    }

    /// Launches the AppStore in two situations when the user clicked the `Update` button in the UIAlertController modal.
    ///
    /// This function is marked `public` as a convenience for those developers who decide to build a custom alert modal
    /// instead of using Siren's prebuilt update alert.
    func launchAppStore() {
        guard let appID = appID,
            let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else {
                resultsHandler?(nil, .malformedURL)
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

// MARK: - Version Check and Alert Presentation Flow

private extension Siren {
    /// Initiates the unidirectional version checking flow.
    func performVersionCheck() {
        alertPresentationDate = UserDefaults.alertPresentationDate
        apiManager.performVersionCheckRequest { [weak self] (lookupModel, error) in
            guard let self = self else { return }
            guard let lookupModel = lookupModel, error == nil else {
                self.resultsHandler?(nil, error)
                return
            }

            self.validate(model: lookupModel)
        }
    }

    /// Validates the parsed and mapped iTunes Lookup Model
    /// to guarantee all the relevant data was returned before
    /// attempting to present an alert.
    ///
    /// - Parameter model: The iTunes Lookup Model.
    func validate(model: LookupModel) {
        // Check if the latest version is compatible with current device's version of iOS.
        guard DataParser.isUpdateCompatibleWithDeviceOS(for: model) else {
            resultsHandler?(nil, .appStoreOSVersionUnsupported)
            return
        }

        // Check and store the App ID .
        guard let appID = model.results.first?.appID else {
            resultsHandler?(nil, .appStoreAppIDFailure)
            return
        }
        self.appID = appID

        // Check and store the current App Store version.
        guard let currentAppStoreVersion = model.results.first?.version else {
            resultsHandler?(nil, .appStoreVersionArrayFailure)
            return
        }

        // Check if the App Store version is newer than the currently installed version.
        guard DataParser.isAppStoreVersionNewer(installedVersion: currentInstalledVersion,
                                                appStoreVersion: currentAppStoreVersion) else {
            resultsHandler?(nil, .noUpdateAvailable)
            return
        }

        // Check the release date of the current version.
        guard let currentVersionReleaseDate = model.results.first?.currentVersionReleaseDate,
            let daysSinceRelease = Date.days(since: currentVersionReleaseDate) else {
                resultsHandler?(nil, .currentVersionReleaseDate)
                return
        }

        // Check if applicaiton has been released for the amount of days defined by the app consuming Siren.
        guard daysSinceRelease >= rulesManager.releasedForDays else {
            resultsHandler?(nil, .releasedTooSoon(daysSinceRelease: daysSinceRelease,
                                                     releasedForDays: rulesManager.releasedForDays))
            return
        }

        determineIfAlertPresentationRulesAreSatisfied(forCurrentAppStoreVersion: currentAppStoreVersion, andLookupModel: model)
    }

    /// Determines if the update alert can be presented based on the
    /// rules set in the `RulesManager` and the the skip version settings.
    ///
    /// - Parameters:
    ///   - currentAppStoreVersion: The curren version of the app in the App Store.
    ///   - model: The iTunes Lookup Model.
    func determineIfAlertPresentationRulesAreSatisfied(forCurrentAppStoreVersion currentAppStoreVersion: String, andLookupModel model: LookupModel) {
        // Did the user:
        // - request to skip being prompted with version update alerts for a specific version
        // - and is the latest App Store update the same version that was requested?
        if let previouslySkippedVersion = UserDefaults.storedSkippedVersion,
            let currentInstalledVersion = currentInstalledVersion,
            !currentAppStoreVersion.isEmpty,
            currentAppStoreVersion != previouslySkippedVersion {
            resultsHandler?(nil, .skipVersionUpdate(installedVersion: currentInstalledVersion, appStoreVersion: currentAppStoreVersion))
                return
        }

        let updateType = DataParser.parseForUpdate(forInstalledVersion: currentInstalledVersion,
                                                   andAppStoreVersion: currentAppStoreVersion)
        let rules = rulesManager.loadRulesForUpdateType(updateType)

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
                resultsHandler?(nil, .recentlyPrompted)
            }
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
                      model: LookupModel,
                      andUpdateType updateType: RulesManager.UpdateType) {
        presentationManager.presentAlert(withRules: rules, forCurrentAppStoreVersion: currentAppStoreVersion) { [weak self] alertAction in
            guard let self = self else { return }
            let results = Results(alertAction: alertAction,
                                  localization: self.presentationManager.localization,
                                  lookupModel: model,
                                  updateType: updateType)
            self.resultsHandler?(results, nil)
        }
    }
}

// MARK: - Observers

private extension Siren {
    /// Add app state observers
    func addObservers() {
        addForegroundObserver()
        addBackgroundObserver()
    }

    /// Adds an observer that listens for app launching/relaunching.
    func addForegroundObserver() {
        guard didBecomeActiveObserver == nil else { return }
        didBecomeActiveObserver = NotificationCenter
            .default
            .addObserver(forName: UIApplication.didBecomeActiveNotification,
                         object: nil,
                         queue: nil) { [weak self] _ in
                            guard let self = self else { return }
                            self.performVersionCheck()
        }
    }

    /// Adds an observer that listens for when the app is sent to the background.
    func addBackgroundObserver() {
        guard didEnterBackgroundObserver == nil else { return }
        didEnterBackgroundObserver = NotificationCenter
            .default
            .addObserver(forName: UIApplication.didEnterBackgroundNotification,
                         object: nil,
                         queue: nil) { [weak self] _ in
                            guard let self = self else { return }
                            self.presentationManager.alertController?.dismiss(animated: true, completion: nil)
        }
    }
}
