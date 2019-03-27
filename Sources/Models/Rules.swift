//
//  Rules.swift
//  Siren
//
//  Created by Sabintsev, Arthur on 11/18/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Alert Presentation Rules for Siren.
public struct Rules {
    /// The type of alert that should be presented.
    let alertType: AlertType

    /// The frequency in which a the user is prompted to update the app
    /// once a new version is available in the App Store and if they have not updated yet.
    let frequency: UpdatePromptFrequency

    /// Initializes the alert presentation rules.
    ///
    /// - Parameters:
    ///   - frequency: How often a user should be prompted to update the app once a new version is available in the App Store.
    ///   - alertType: The type of alert that should be presented.
    public init(promptFrequency frequency: UpdatePromptFrequency,
                forAlertType alertType: AlertType) {
        self.frequency = frequency
        self.alertType = alertType
    }

    /// Performs a version check immediately, but allows the user to skip updating the app until the next time the app becomes active.
    public static var annoying: Rules {
        return Rules(promptFrequency: .immediately, forAlertType: .option)
    }

    /// Performs a version check immediately and forces the user to update the app.
    public static var critical: Rules {
        return Rules(promptFrequency: .immediately, forAlertType: .force)
    }

    /// Performs a version check once a day, but allows the user to skip updating the app until
    /// the next time the app becomes active or skipping the update all together until another version is released.
    ///
    /// This is the default setting.
    public static var `default`: Rules {
        return Rules(promptFrequency: .daily, forAlertType: .skip)
    }

    /// Performs a version check weekly, but allows the user to skip updating the app until the next time the app becomes active.
    public static var hinting: Rules {
        return Rules(promptFrequency: .weekly, forAlertType: .option)
    }

    /// Performs a version check daily, but allows the user to skip updating the app until the next time the app becomes active.
    public static var persistent: Rules {
        return Rules(promptFrequency: .daily, forAlertType: .option)
    }

    /// Performs a version check weekly, but allows the user to skip updating the app until
    /// the next time the app becomes active or skipping the update all together until another version is released.
    public static var relaxed: Rules {
        return Rules(promptFrequency: .weekly, forAlertType: .skip)
    }
}

// Rules-related Constants
public extension Rules {
    /// Determines the type of alert to present after a successful version check has been performed.
    enum AlertType {
        /// Forces the user to update your app (1 button alert).
        case force
        /// Presents the user with option to update app now or at next launch (2 button alert).
        case option
        /// Presents the user with option to update the app now, at next launch, or to skip this version all together (3 button alert).
        case skip
        /// Doesn't present the alert.
        /// Use this option if you would like to present a custom alert to the end-user.
        case none
    }

    /// Determines the frequency in which the user is prompted to update the app
    /// once a new version is available in the App Store and if they have not updated yet.
    enum UpdatePromptFrequency: UInt {
        /// Version check performed every time the app is launched.
        case immediately = 0
        /// Version check performed once a day.
        case daily = 1
        /// Version check performed once a week.
        case weekly = 7
    }
}
