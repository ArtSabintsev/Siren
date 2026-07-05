//
//  PresentationManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// PresentationManager for Siren
public class PresentationManager {
    /// Return results or errors obtained from performing a version check with Siren.
    typealias CompletionHandler = (AlertAction, String?) -> Void

    /// The localization data structure that will be used to construct localized strings for the update alert.
    let localization: Localization

    /// The tint color of the `UIAlertController` buttons.
    let tintColor: UIColor?

    /// The descriptive update message of the `UIAlertController`.
    let alertMessage: String

    /// The main message of the `UIAlertController`.
    let alertTitle: String

    /// The "Next time" button text of the `UIAlertController`.
    let nextTimeButtonTitle: String

    /// The "Skip this version" button text of the `UIAlertController`.
    let skipButtonTitle: String

    /// The "Update" button text of the `UIAlertController`.
    let updateButtonTitle: String

    /// The instance of the `UIAlertController` used to present the update alert.
    var alertController: UIAlertController?

    /// The `UIWindow` instance that presents the `SirenViewController`.
    ///
    /// Created on demand for each presentation so that a launch-time failure
    /// to find a foreground scene does not permanently prevent alerts from showing.
    private var updaterWindow: UIWindow?

    /// `PresentationManager`'s public initializer.
    ///
    /// - Parameters:
    ///     - tintColor: The alert's tintColor. Settings this to `nil` defaults to the system default color.
    ///     - appName: The name of the app (overrides the default/bundled name).
    ///     - alertTitle: The title field of the `UIAlertController`.
    ///     - alertMessage: The `message` field of the `UIAlertController`.
    ///     - nextTimeButtonTitle: The `title` field of the Next Time Button `UIAlertAction`.
    ///     - skipButtonTitle: The `title` field of the Skip Button `UIAlertAction`.
    ///     - updateButtonTitle: The `title` field of the Update Button `UIAlertAction`.
    ///     - forceLanguage: The language the alert to which the alert should be set. If `nil`, it falls back to the device's preferred locale.
    public init(alertTintColor tintColor: UIColor? = nil,
                appName: String? = nil,
                alertTitle: String  = AlertConstants.alertTitle,
                alertMessage: String  = AlertConstants.alertMessage,
                updateButtonTitle: String  = AlertConstants.updateButtonTitle,
                nextTimeButtonTitle: String  = AlertConstants.nextTimeButtonTitle,
                skipButtonTitle: String  = AlertConstants.skipButtonTitle,
                forceLanguageLocalization forceLanguage: Localization.Language? = nil) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.localization = Localization(appName: appName, andForceLanguageLocalization: forceLanguage)
        self.nextTimeButtonTitle = nextTimeButtonTitle
        self.updateButtonTitle = updateButtonTitle
        self.skipButtonTitle = skipButtonTitle
        self.tintColor = tintColor
    }

    /// The default `PresentationManager`.
    ///
    /// By default:
    /// - There is no tint color (defaults to Apple's system `blue` color.)
    /// - The name of the app is equal to the name that appears in `Info.plist`.
    /// - The strings are all set to that of the user's device localization (if supported) or it falls back to English.
    public static let `default` = PresentationManager()
}

// MARK: - Alert Lifecycle

extension PresentationManager {

    /// Constructs the localized update alert `UIAlertController` object.
    ///
    /// - Parameters:
    ///   - rules: The rules that are used to define the type of alert that should be presented.
    ///   - currentAppStoreVersion: The current version of the app in the App Store.
    ///   - handler: The completion handler that returns the an `AlertAction` depending on the type of action the end-user took.
    func presentAlert(withRules rules: Rules,
                      forCurrentAppStoreVersion currentAppStoreVersion: String,
                      completion handler: CompletionHandler?) {
        // If an update alert is already on screen, leave it in place
        // rather than tearing it down and replacing it.
        if let updaterWindow = updaterWindow, !updaterWindow.isHidden {
            return
        }

        // If the alertType is .none, an alert is not presented, but the
        // presentation date is still recorded so that custom alerts driven
        // by the results handler respect the update prompt frequency rules.
        if rules.alertType == .none {
            UserDefaults.alertPresentationDate = Date()
            handler?(.unknown, nil)
            return
        }

        // Alert Title
        let alertTitle: String
        if self.alertTitle == AlertConstants.alertTitle {
            alertTitle = localization.alertTitle()
        } else {
            alertTitle = self.alertTitle
        }

        // Alert Message
        let alertMessage: String
        if self.alertMessage == AlertConstants.alertMessage {
            alertMessage = localization.alertMessage(forCurrentAppStoreVersion: currentAppStoreVersion)
        } else {
            alertMessage = self.alertMessage
        }

        // The window is created per presentation so that it is always
        // attached to the currently foregrounded scene.
        guard let window = updaterWindow ?? createWindow() else { return }
        updaterWindow = window

        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        self.alertController = alertController

        if let tintColor = tintColor {
            alertController.view.tintColor = tintColor
        }

        switch rules.alertType {
        case .force:
            alertController.addAction(updateAlertAction(completion: handler))
        case .option:
            alertController.addAction(nextTimeAlertAction(completion: handler))
            alertController.addAction(updateAlertAction(completion: handler))
        case .skip:
            alertController.addAction(updateAlertAction(completion: handler))
            alertController.addAction(nextTimeAlertAction(completion: handler))
            alertController.addAction(skipAlertAction(forCurrentAppStoreVersion: currentAppStoreVersion, completion: handler))
        case .none:
            break
        }

        // The presentation date is only recorded once the alert is actually shown,
        // so that a failed presentation does not suppress the next opportunity.
        UserDefaults.alertPresentationDate = Date()
        alertController.show(window: window)
    }

    /// Dismisses the update alert and releases the `alertController` and `updaterWindow`.
    func cleanUp() {
        if let updaterWindow = updaterWindow {
            alertController?.hide(window: updaterWindow)
            updaterWindow.resignKey()
        }
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
        updaterWindow = nil
    }
}

// MARK: - Alert Actions

private extension PresentationManager {

    /// The `UIAlertAction` that is executed when the `Update` option is selected.
    ///
    /// - Parameters:
    ///   - handler: The completion handler that returns the `.update` option.
    /// - Returns: The `Update` alert action.
    func updateAlertAction(completion handler: CompletionHandler?) -> UIAlertAction {
        let title: String
        if updateButtonTitle == AlertConstants.updateButtonTitle {
            title = localization.updateButtonTitle()
        } else {
            title = updateButtonTitle
        }

        let action = UIAlertAction(title: title, style: .default) { _ in
            self.cleanUp()
            handler?(.appStore, nil)
            return
        }

        return action
    }

    /// The `UIAlertAction` that is executed when the `Next time` option is selected.
    ///
    /// - Parameters:
    ///   - handler: The completion handler that returns the `.nextTime` option.
    /// - Returns: The `Next time` alert action.
    func nextTimeAlertAction(completion handler: CompletionHandler?) -> UIAlertAction {
        let title: String
        if nextTimeButtonTitle == AlertConstants.nextTimeButtonTitle {
            title = localization.nextTimeButtonTitle()
        } else {
            title = nextTimeButtonTitle
        }

        let action = UIAlertAction(title: title, style: .default) { _ in
            self.cleanUp()
            handler?(.nextTime, nil)
            return
        }

        return action
    }

    /// The `UIAlertAction` that is executed when the `Skip this version` option is selected.
    ///
    /// - Parameters:
    ///   - currentAppStoreVersion: The current version of the app in the App Store.
    ///   - handler: The completion handler that returns the `.skip` option.
    /// - Returns: The `Skip this version` alert action.
    func skipAlertAction(forCurrentAppStoreVersion currentAppStoreVersion: String, completion handler: CompletionHandler?) -> UIAlertAction {
        let title: String
        if skipButtonTitle == AlertConstants.skipButtonTitle {
            title = localization.skipButtonTitle()
        } else {
            title = skipButtonTitle
        }

        let action = UIAlertAction(title: title, style: .default) { _ in
            self.cleanUp()
            handler?(.skip, currentAppStoreVersion)
            return
        }

        return action
    }
}

// MARK: - Helpers

private extension PresentationManager {
    private func createWindow() -> UIWindow? {
        guard let windowScene = getFirstForegroundScene() else { return nil }

        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = UIWindow.Level.alert + 1

        let viewController = SirenViewController()
        viewController.retainedWindow = window
        window.rootViewController = viewController

        return window
    }

    @available(iOS 13.0, tvOS 13.0, *)
    private func getFirstForegroundScene() -> UIWindowScene? {
        let connectedScenes = UIApplication.shared.connectedScenes
        if let windowActiveScene = connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return windowActiveScene
        } else if let windowInactiveScene = connectedScenes.first(where: { $0.activationState == .foregroundInactive }) as? UIWindowScene {
            return windowInactiveScene
        } else {
            return nil
        }
    }
}
