//
//  BundleExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Bundle Extension for Siren

extension Bundle {
    private struct Constants {
        static let bundleExtension = "bundle"
        static let displayName = "CFBundleDisplayName"
        static let projectExtension = "lproj"
        static let shortVersionString = "CFBundleShortVersionString"
        static let table = "SirenLocalizable"
    }

    final class func version() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: Constants.shortVersionString) as? String
    }

    final class func bundleID() -> String? {
        return Bundle.main.bundleIdentifier
    }

    final class func sirenBundlePath() -> String? {
        return Bundle(for: Siren.self).path(forResource: "\(Siren.self)", ofType: Constants.bundleExtension)
    }

    final class func sirenForcedBundlePath(forceLanguageLocalization: Localization.Language) -> String? {
        guard let path = sirenBundlePath() else { return nil }
        let name = forceLanguageLocalization.rawValue

        return Bundle(path: path)?.path(forResource: name, ofType: Constants.projectExtension)
    }

    final class func localizedString(forKey key: String, andForceLanguageLocalization language: Localization.Language?) -> String {
        guard var path = sirenBundlePath() else {
            return key
        }

        if let language = language,
            let forcedPath = sirenForcedBundlePath(forceLanguageLocalization: language) {
            path = forcedPath
        }

        return Bundle(path: path)?.localizedString(forKey: key, value: key, table: Constants.table) ?? key
    }

    final class func bestMatchingAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: Constants.displayName) as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

        return bundleDisplayName ?? bundleName ?? ""
    }
}
