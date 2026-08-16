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
        /// Namespaced key for the last alert presentation timestamp.
        case storedVersionCheckDate = "com.sabintsev.siren.StoredVersionCheckDate"
        /// Namespaced key for the version the user skipped.
        case storedSkippedVersion = "com.sabintsev.siren.StoredSkippedVersion"
        /// Legacy un-namespaced key. Read as a fallback so existing skip/date state survives the rename.
        case legacyVersionCheckDate = "StoredVersionCheckDate"
        /// Legacy un-namespaced key. Read as a fallback so existing skip state survives the rename.
        case legacySkippedVersion = "StoredSkippedVersion"
    }

    /// Sets and Gets a `UserDefault` around storing a version that the user wants to skip updating.
    static var storedSkippedVersion: String? {
        get {
            return standard.string(forKey: SirenKeys.storedSkippedVersion.rawValue)
                ?? standard.string(forKey: SirenKeys.legacySkippedVersion.rawValue)
        } set {
            standard.set(newValue, forKey: SirenKeys.storedSkippedVersion.rawValue)
        }
    }

    /// Sets and Gets a `UserDefault` around the last time the user was presented a version update alert.
    static var alertPresentationDate: Date? {
        get {
            return (standard.object(forKey: SirenKeys.storedVersionCheckDate.rawValue) as? Date)
                ?? (standard.object(forKey: SirenKeys.legacyVersionCheckDate.rawValue) as? Date)
        } set {
            standard.set(newValue, forKey: SirenKeys.storedVersionCheckDate.rawValue)
        }
    }
}
