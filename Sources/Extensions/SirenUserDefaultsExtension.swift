//
//  SirenUserDefaultsExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Siren-specific UserDefaults Keys
private enum SirenKeys: String {
    /// Key that notifies Siren to perform a version check and present
    /// the Siren alert the next time the user launches the app.
    case PerformVersionCheckOnSubsequentLaunch

    /// Key that stores the timestamp of the last version check in UserDefaults.
    case StoredVersionCheckDate

    /// Key that stores the version that a user decided to skip in UserDefaults.
    case StoredSkippedVersion
}

// MARK: - UserDefaults Extension for Siren

extension UserDefaults {
    static var shouldPerformVersionCheckOnSubsequentLaunch: Bool {
        get {
            print(#function, standard.bool(forKey: SirenKeys.PerformVersionCheckOnSubsequentLaunch.rawValue))
            return standard.bool(forKey: SirenKeys.PerformVersionCheckOnSubsequentLaunch.rawValue)
        } set {
            standard.set(newValue, forKey: SirenKeys.PerformVersionCheckOnSubsequentLaunch.rawValue)
        }
    }

    static var storedSkippedVersion: String? {
        get {
            return standard.string(forKey: SirenKeys.StoredSkippedVersion.rawValue)
        } set {
            standard.set(newValue, forKey: SirenKeys.StoredSkippedVersion.rawValue)
        }
    }

    static var storedVersionCheckDate: Date? {
        get {
            return standard.object(forKey: SirenKeys.StoredVersionCheckDate.rawValue) as? Date
        } set {
            standard.set(newValue, forKey: SirenKeys.StoredVersionCheckDate.rawValue)
        }
    }
}
