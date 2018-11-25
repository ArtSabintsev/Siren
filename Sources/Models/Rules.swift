//
//  Rules.swift
//  Siren
//
//  Created by Sabintsev, Arthur on 11/18/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

public struct Rules {

    let alertType: Constants.AlertType
    let frequency: Constants.VersionCheckFrequency

    /// When this is set, the alert will only show up if the current version has already been released for X days.
    /// Defaults to 1 day (in the initializer) to avoid an issue where Apple updates the JSON faster than the app binary propogates to the App Store.
    let releaseFordDays: Int

    public init(versionCheckFrequency frequency: Constants.VersionCheckFrequency,
                forAlertType alertType: Constants.AlertType,
                showAlertAfterCurrentVersionHasBeenReleasedForDays releaseFordDays: Int = 1) {
        self.frequency = frequency
        self.alertType = alertType
        self.releaseFordDays = releaseFordDays
    }

    public static var `default`: Rules {
        return Rules(versionCheckFrequency: .daily, forAlertType: .option)
    }

    public static var critical: Rules {
        return Rules(versionCheckFrequency: .immediately, forAlertType: .force)
    }
}
