//
//  SirenUserDefaultsExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - UserDefaults Extension for Siren

extension UserDefaults {
    /// Siren-specific UserDefaults Keys
    enum SirenKeys: String {
        /// Keey that notifies Siren to perform a version check and present
        /// the Siren alert the next time the user launches the app.
        case PerformVersionCheckOnSubsequentLaunch

        /// Key that stores the timestamp of the last version check in UserDefaults.
        case StoredVersionCheckDate

        /// Key that stores the version that a user decided to skip in UserDefaults.
        case StoredSkippedVersion
    }

    static var shouldPerformVersionCheckOnSubsequentLaunch: Bool {
        return standard.bool(forKey: SirenKeys.PerformVersionCheckOnSubsequentLaunch.rawValue)
    }
}
