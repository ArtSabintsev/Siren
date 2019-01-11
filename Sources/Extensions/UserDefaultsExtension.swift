//
//  UserDefaultsExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// `UserDefaults` Extension for Siren.
extension UserDefaults {
    /// Siren-specific `UserDefaults` Keys
    private enum SirenKeys: String {
        /// Key that notifies Siren to perform a version check and present
        /// the Siren alert the next time the user launches the app.
        case PerformVersionCheckOnSubsequentLaunch

        /// Key that stores the timestamp of the last version check.
        case StoredVersionCheckDate

        /// Key that stores the version that a user decided to skip.
        case StoredSkippedVersion
    }

    /// Sets and Gets a `UserDefault` around storing a version that the user wants to skip updating.
    static var storedSkippedVersion: String? {
        get {
            return standard.string(forKey: SirenKeys.StoredSkippedVersion.rawValue)
        } set {
            standard.set(newValue, forKey: SirenKeys.StoredSkippedVersion.rawValue)
        }
    }

    /// Sets and Gets a `UserDefault` around the last time the user was presented a version update alert.
    static var alertPresentationDate: Date? {
        get {
            return standard.object(forKey: SirenKeys.StoredVersionCheckDate.rawValue) as? Date
        } set {
            standard.set(newValue, forKey: SirenKeys.StoredVersionCheckDate.rawValue)
        }
    }
}
