//
//  Rules.swift
//  Siren
//
//  Created by Sabintsev, Arthur on 11/18/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

public struct Rules {

    let alertType: AlertType
    let frequency: VersionCheckFrequency

    public init(checkFrequency frequency: VersionCheckFrequency,
                forAlertType alertType: AlertType) {
        self.frequency = frequency
        self.alertType = alertType
    }

    /// Performs a version check immediately, but allows the user to skip updating the app until the next time the app becomes active.
    public static var annoying: Rules {
        return Rules(checkFrequency: .immediately, forAlertType: .option)
    }

    /// Performs a version check immediately and forces the user to update the app.
    public static var critical: Rules {
        return Rules(checkFrequency: .immediately, forAlertType: .force)
    }

    /// Performs a version check once a day, but allows the user to skip updating the app until
    /// the next time the app becomes active or skipping the update all together until another version is released.
    ///
    /// This is the default setting.
    public static var `default`: Rules {
        return Rules(checkFrequency: .daily, forAlertType: .skip)
    }

    /// Performs a version check daily, but allows the user to skip updating the app until the next time the app becomes active.
    public static var persistent: Rules {
        return Rules(checkFrequency: .daily, forAlertType: .option)
    }

    /// Performs a version check weekly, but allows the user to skip updating the app until
    /// the next time the app becomes active or skipping the update all together until another version is released.
    public static var relaxed: Rules {
        return Rules(checkFrequency: .weekly, forAlertType: .skip)
    }
}

// Rules-related Constants
public extension Rules {
    /// Determines the type of alert to present after a successful version check has been performed.
    public enum AlertType {
        /// Forces the user to update your app (1 button alert).
        case force
        /// Presents the user with option to update app now or at next launch (2 button alert).
        case option
        /// Presents the user with option to update the app now, at next launch, or to skip this version all together (3 button alert).
        case skip
        /// Doesn't present the alert.
        ///
        /// Use this option if you would like to present a custom alert to the end user.
        case none
    }

    /// Determines the frequency in which the the version check is performed and the user is prompted to update the app.
    public enum VersionCheckFrequency: UInt {
        /// Version check performed every time the app is launched.
        case immediately = 0
        /// Version check performed once a day.
        case daily = 1
        /// Version check performed once a week.
        case weekly = 7
    }
}
