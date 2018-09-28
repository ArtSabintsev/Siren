//
//  SirenBundleExtension.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Bundle Extension for Siren

extension Bundle {
    final class func bundleID() -> String? {
        return Bundle.main.bundleIdentifier
    }

    final class func sirenBundlePath() -> String? {
        return Bundle(for: Siren.self).path(forResource: "Siren", ofType: "bundle")
    }

    final class func sirenForcedBundlePath(forceLanguageLocalization: Siren.LanguageType) -> String? {
        guard let path = sirenBundlePath() else { return nil }
        let name = forceLanguageLocalization.rawValue

        return Bundle(path: path)?.path(forResource: name, ofType: "lproj")
    }

    final class func localizedString(forKey key: String, forceLanguageLocalization: Siren.LanguageType?) -> String? {
        guard var path = sirenBundlePath() else { return nil }
        let table = "SirenLocalizable"

        if let forceLanguageLocalization = forceLanguageLocalization,
            let forcedPath = sirenForcedBundlePath(forceLanguageLocalization: forceLanguageLocalization) {
            path = forcedPath
        }

        return Bundle(path: path)?.localizedString(forKey: key, value: key, table: table)
    }

    final class func bestMatchingAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

        return bundleDisplayName ?? bundleName ?? ""
    }
}

// MARK: - Bundle Extension for Testing Siren

extension Bundle {
    func testLocalizedString(forKey key: String, forceLanguageLocalization: Siren.LanguageType?) -> String? {
        return Bundle.localizedString(forKey: key, forceLanguageLocalization: forceLanguageLocalization)
    }
}
