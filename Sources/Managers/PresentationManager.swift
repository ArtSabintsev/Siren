//
//  PresentationManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// PresentationManager for Siren
public struct PresentationManager {
    /// Return results or errors obtained from performing a version check with Siren.
    typealias CompletionHandler = (AlertAction) -> Void

    /// The localization data structure that will be used to construct localized strings for the update alert.
    let localization: Localization

    /// The tint color of the `UIAlertController` buttons.
    let tintColor: UIColor?

    /// The descriptive update message of the `UIAlertController`.
    let alertMessage: NSAttributedString

    /// The main message of the `UIAlertController`.
    let alertTitle: NSAttributedString

    /// The "Next time" button text of the `UIAlertController`.
    let nextTimeButtonMessage: NSAttributedString

    /// The "Skip this version" button text of the `UIAlertController`.
    let skipVersionButtonMessage: NSAttributedString

    /// The "Update now" button text of the `UIAlertController`.
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

    /// The default `PresentationManager`.
    ///
    /// By default:
    /// - There is no tint color (defaults to Apple's system `blue` color.)
    /// - The name of the app is equal to the name that appears in `Info.plist`.
    /// - The strings are all set to that of the user's device localization (if supported) or it falls back to English.
    public static let `default` = PresentationManager()
}

extension PresentationManager {

    /// Constructs the localized update alert `UIAlertController` object.
    ///
    /// - Parameters:
    ///   - rules: The rules that are used to define the type of alert that should be presented.
    ///   - currentAppStoreVersion: The current version of the app in the App Store.
    ///   - handler: The completion handler that returns the an `AlertAction` depending on the type of action the end-user took.
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
            handler?(.unknown)
        }

        // If the alertType is .none, an alert will not be presneted.
        // If the `updaterWindow` is not hidden, than an alert is already presented.
        // The latter prevents `UIAlertControllers` from appearing on top of each other.
        if rules.alertType != .none && updaterWindow.isHidden {
            alertController?.show(window: updaterWindow)
        }
    }

    /// The `UIAlertAction` that is executed when the `Update now` option is selected.
    ///
    /// - Parameters:
    ///   - handler: The completion handler that returns the `.update` option.
    /// - Returns: The `Update now` alert action.
    private func updateAlertAction(completion handler: CompletionHandler?) -> UIAlertAction {
        let action = UIAlertAction(title: localization.updateButtonTitle(), style: .default) { _ in
            self.alertController?.hide(window: self.updaterWindow)
            Siren.shared.launchAppStore()

            handler?(.appStore)
            return
        }

        return action
    }

    /// The `UIAlertAction` that is executed when the `Next time` option is selected.
    ///
    /// - Parameters:
    ///   - handler: The completion handler that returns the `.nextTime` option.
    /// - Returns: The `Next time` alert action.
    private func nextTimeAlertAction(completion handler: CompletionHandler?) -> UIAlertAction {
        let action = UIAlertAction(title: localization.nextTimeButtonTitle(), style: .default) { _ in
            self.alertController?.hide(window: self.updaterWindow)
            UserDefaults.shouldPerformVersionCheckOnSubsequentLaunch = true

            handler?(.nextTime)
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
    private func skipAlertAction(forCurrentAppStoreVersion currentAppStoreVersion: String, completion handler: CompletionHandler?) -> UIAlertAction {
        let action = UIAlertAction(title: localization.skipButtonTitle(), style: .default) { _ in
            UserDefaults.storedSkippedVersion = currentAppStoreVersion
            UserDefaults.standard.synchronize()

            self.alertController?.hide(window: self.updaterWindow)

            handler?(.skip)
            return
        }

        return action
    }
}
