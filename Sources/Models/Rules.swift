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

    public static var `default`: Rules {
        return Rules(checkFrequency: .daily, forAlertType: .skip)
    }

    public static var critical: Rules {
        return Rules(checkFrequency: .immediately, forAlertType: .force)
    }

    public static var persistent: Rules {
        return Rules(checkFrequency: .daily, forAlertType: .option)
    }

    public static var relaxed: Rules {
        return Rules(checkFrequency: .weekly, forAlertType: .skip)
    }
}

// MARK: - Rules-related Constants

public extension Rules {
    /// Determines the type of alert to present after a successful version check has been performed.
    public enum AlertType {
        /// Forces the user to update your app (1 button alert).
        case force
        /// Presents the user with option to update app now or at next launch (2 button alert).
        case option
        /// Presents the user with option to update the app now, at next launch, or to skip this version all together (3 button alert).
        case skip
        /// Doesn't show the alert, but instead returns a localized message for use in a
        /// custom UI within the `sirenDidDetectNewVersionWithoutAlert(...)` delegate method.
        case none
    }

    /// Determines the frequency in which the the version check is performed and the user is prompted to update the app.
    public enum VersionCheckFrequency: Int {
        /// Version check performed every time the app is launched.
        case immediately = 0
        /// Version check performed once a day.
        case daily = 1
        /// Version check performed once a week.
        case weekly = 7
    }

}
