//
//  AlertConstants.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/18/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// The default constants used for the alert messaging.
public struct AlertConstants {
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
