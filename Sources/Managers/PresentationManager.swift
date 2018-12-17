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
    /// The default constants used for the alert messaging.
    public struct Constants {
        /// The text that conveys the message that there is an app update available
        public static let alertMessage = NSAttributedString(string: "A new version of %@ is available. Please update to version %@ now.")

        /// The alert title which defaults to *Update Available*.
        public static let alertTitle = NSAttributedString(string: "Update Available")

        /// The button text that conveys the message that the user should be prompted to update next time the app launches.
        public static let nextTimeButtonTitle = NSAttributedString(string: "Next time")

        /// The text that conveys the message that the the user wants to skip this verison update.
        public static let skipButtonTitle = NSAttributedString(string: "Skip this version")

        /// The button text that conveys the message that the user would like to update the app right away.
        public static let updateButtonTitle = NSAttributedString(string: "Update")
    }

    let tintColor: UIColor?
    let alertMessage: NSAttributedString
    let alertTitle: NSAttributedString
    let nextTimeButtonMessage: NSAttributedString
    let skipVersionButtonMessage: NSAttributedString
    let updateButtonMessage: NSAttributedString

    /// The name of your app. Defaults to name of the app that's stored in `Info.plist`.
    var appName: String = Bundle.bestMatchingAppName()

    /// Overrides the default localization of a user's device when presenting the update message and button titles in the alert.
    /// See the Siren.LanguageType enum for more details.
    let forceLanguageLocalization: Localization.Language?

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
    ///     - forceLanguageLocalization: The language the alert should to which the alert should be set. Defaults to the device's preferred locale.
    public init(alertTintColor tintColor: UIColor? = nil,
                appName: String? = nil,
                alertTitle: NSAttributedString  = Constants.alertTitle,
                alertMessage: NSAttributedString  = Constants.alertMessage,
                updateButtonTitle: NSAttributedString  = Constants.updateButtonTitle,
                nextTimeButtonTitle: NSAttributedString  = Constants.nextTimeButtonTitle,
                skipButtonTitle: NSAttributedString  = Constants.skipButtonTitle,
                forceLanguageLocalization: Localization.Language? = nil) {
        self.tintColor = tintColor
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.nextTimeButtonMessage = nextTimeButtonTitle
        self.updateButtonMessage = updateButtonTitle
        self.skipVersionButtonMessage = skipButtonTitle
        self.forceLanguageLocalization = forceLanguageLocalization

        if let appName = appName {
            self.appName = appName
        }
    }

    /// The default `PresentationManager`
    ///
    /// By default:
    /// - There is no tint color.
    /// - The name of the app is equal to the name that appears in `Info.plist`.
    /// - The strings are all set to that of the user's device localization (if supported) or it falls back to English.
    public static let `default` = PresentationManager()
}
