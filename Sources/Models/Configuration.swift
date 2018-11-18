//
//  Configuration.swift
//  Siren
//
//  Created by Sabintsev, Arthur on 11/18/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

public struct Configuration {

    static var `default`: Configuration {
        return Configuration(versionCheckFrequency: .daily, forAlertType: .option)
    }

    static var critical: Configuration {
        return Configuration(versionCheckFrequency: .immediately, forAlertType: .force)
    }

    let alertType: Constants.AlertType
    let frequency: Constants.VersionCheckFrequency

    init(versionCheckFrequency frequency: Constants.VersionCheckFrequency,
         forAlertType alertType: Constants.AlertType) {
        self.frequency = frequency
        self.alertType = alertType
    }
}
