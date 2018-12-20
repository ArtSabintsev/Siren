//
//  PresentationManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Siren Alert Messaging Customization

/// Allows the overriding of all the `UIAlertController` and `UIActionSheet` Strings to which Siren defaults.
///
/// - Warning: Overriding any of these keys will result in the loss of the built-in internationalization that Siren provides.
///
/// As `SirenAlertMessaging` is a Struct, one _or_ more keys can be modified. Overriding only one string will result in the other keys retaining their default (and internationalizable) values.
public struct PresentationManager {
    /// Return results or errors obtained from performing a version check with Siren.
    typealias CompletionHandler = (AlertAction?, KnownError?) -> Void

    /// The default `PresentationManager`
    ///
    /// By default:
    /// - There is no tint color.
    /// - The name of the app is equal to the name that appears in `Info.plist`.
    /// - The strings are all set to that of the user's device localization (if supported) or it falls back to English.
    public static let `default` = PresentationManager()

    let localization: Localization
    let tintColor: UIColor?

    let alertMessage: NSAttributedString
    let alertTitle: NSAttributedString
    let nextTimeButtonMessage: NSAttributedString
    let skipVersionButtonMessage: NSAttributedString
    let updateButtonMessage: NSAttributedString

    /// The instance of the `UIAlertController` used to present the update alert.
    private var alertController: UIAlertController?

    /// The `UIWindow` instance that presents the `SirenViewController`.
    private var updaterWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = SirenViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        return window
    }

    /// The public initializer
    ///
    /// - Parameters:
    ///     - tintColor: The alert's tintColor. Settings this to `nil` defaults to the system default color.
    ///     - appName: The name of the app (overrides the default/bundled name).
    ///     - alertTitle: The title field of the `UIAlertController`.
    ///     - alertMessage: The `message` field of the `UIAlertController`.
    ///     - nextTimeButtonTitle: The `title` field of the Next Time Button `UIAlertAction`.
    ///     - skipButtonTitle: The `title` field of the Skip Button `UIAlertAction`.
    ///     - updateButtonTitle: The `title` field of the Update Button `UIAlertAction`.
    ///     - forceLanguage: The language the alert should to which the alert should be set. If `nil`, fallse back to the device's preferred locale.
    public init(alertTintColor tintColor: UIColor? = nil,
                appName: String? = nil,
                alertTitle: NSAttributedString  = AlertConstants.alertTitle,
                alertMessage: NSAttributedString  = AlertConstants.alertMessage,
                updateButtonTitle: NSAttributedString  = AlertConstants.updateButtonTitle,
                nextTimeButtonTitle: NSAttributedString  = AlertConstants.nextTimeButtonTitle,
                skipButtonTitle: NSAttributedString  = AlertConstants.skipButtonTitle,
                forceLanguageLocalization forceLanguage: Localization.Language? = nil) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.localization = Localization(appName: appName, andForceLanguageLocalization: forceLanguage)
        self.nextTimeButtonMessage = nextTimeButtonTitle
        self.updateButtonMessage = updateButtonTitle
        self.skipVersionButtonMessage = skipButtonTitle
        self.tintColor = tintColor
    }
}

extension PresentationManager {
    mutating func presentAlert(withRules rules: Rules,
                               forCurrentAppStoreVersion currentAppStoreVersion: String,
                               completion handler: CompletionHandler?) {
        UserDefaults.alertPresentationDate = Date()

        let alertTitle = localization.alertTitle()
        let alertMessage = localization.alertMessage(forCurrentAppStoreVersion: currentAppStoreVersion)

        alertController = UIAlertController(title: alertTitle,
                                            message: alertMessage,
                                            preferredStyle: .alert)

        if let tintColor = tintColor {
            alertController?.view.tintColor = tintColor
        }

        switch rules.alertType {
        case .force:
            alertController?.addAction(updateAlertAction(completion: handler))
        case .option:
            alertController?.addAction(nextTimeAlertAction(completion: handler))
            alertController?.addAction(updateAlertAction(completion: handler))
        case .skip:
            alertController?.addAction(nextTimeAlertAction(completion: handler))
            alertController?.addAction(updateAlertAction(completion: handler))
            alertController?.addAction(skipAlertAction(forCurrentAppStoreVersion: currentAppStoreVersion, completion: handler))
        case .none:
            handler?(.unknown, nil)
        }

        if rules.alertType != .none {
            alertController?.show(window: updaterWindow)
        }
    }

    private func updateAlertAction(completion handler: CompletionHandler?) -> UIAlertAction {
        let action = UIAlertAction(title: localization.updateButtonTitle(), style: .default) { _ in
            self.alertController?.hide(window: self.updaterWindow)
            Siren.shared.launchAppStore()

            handler?(.appStore, nil)
            return
        }

        return action
    }

    private func nextTimeAlertAction(completion handler: CompletionHandler?) -> UIAlertAction {
        let action = UIAlertAction(title: localization.nextTimeButtonTitle(), style: .default) { _ in
            self.alertController?.hide(window: self.updaterWindow)
            UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch = true

            handler?(.nextTime, nil)
            return
        }

        return action
    }

    private func skipAlertAction(forCurrentAppStoreVersion currentAppStoreVersion: String, completion handler: CompletionHandler?) -> UIAlertAction {
        let action = UIAlertAction(title: localization.skipButtonTitle(), style: .default) { _ in
            UserDefaults.storedSkippedVersion = currentAppStoreVersion
            UserDefaults.standard.synchronize()

            self.alertController?.hide(window: self.updaterWindow)

            handler?(.skip, nil)
            return
        }

        return action
    }

}
