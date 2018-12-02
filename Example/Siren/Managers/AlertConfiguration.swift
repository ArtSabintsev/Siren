//
//  AlertConfiguration.swift
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
public struct AlertConfiguration {
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
    let nextTimeButtonMessage: NSAttributedString
    let skipVersionButtonMessage: NSAttributedString
    let updateButtonMessage: NSAttributedString
    let updateMessage: NSAttributedString
    let updateTitle: NSAttributedString

    /// The public initializer
    ///
    /// - Parameters:
    ///     - tintColor: The alert's tintColor. Settings this to `nil` defaults to the system default color.
    ///     - title: The title field of the `UIAlertController`.
    ///     - message: The `message` field of the `UIAlertController`.
    ///     - updateButtonMessage: The `title` field of the Update Button `UIAlertAction`.
    ///     - nextTimeButtonMessage: The `title` field of the Next Time Button `UIAlertAction`.
    ///     - skipVersionButtonMessage: The `title` field of the Skip Button `UIAlertAction`.
    public init(alertTintColor tintColor: UIColor? = nil,
                updateTitle title: NSAttributedString  = Constants.alertTitle,
                updateMessage message: NSAttributedString  = Constants.alertMessage,
                updateButtonMessage: NSAttributedString  = Constants.updateButtonTitle,
                nextTimeButtonMessage: NSAttributedString  = Constants.nextTimeButtonTitle,
                skipVersionButtonMessage: NSAttributedString  = Constants.skipButtonTitle) {
        self.tintColor = tintColor
        self.updateTitle = title
        self.nextTimeButtonMessage = nextTimeButtonMessage
        self.updateButtonMessage = updateButtonMessage
        self.updateMessage = message
        self.skipVersionButtonMessage = skipVersionButtonMessage
    }

    public static let `default` = AlertConfiguration()
}
