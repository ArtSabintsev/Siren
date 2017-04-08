//
//  SirenBundleExtension.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Bundle Extension for Siren

internal extension Bundle {
    class func bundleID() -> String? {
        return Bundle.main.bundleIdentifier
    }

    func sirenBundlePath() -> String {
        return Bundle(for: Siren.self).path(forResource: "Siren", ofType: "bundle") as String!
    }

    func sirenForcedBundlePath(forceLanguageLocalization: Siren.LanguageType) -> String {
        let path = sirenBundlePath()
        let name = forceLanguageLocalization.rawValue
        return Bundle(path: path)!.path(forResource: name, ofType: "lproj")!
    }

    func localizedString(stringKey: String, forceLanguageLocalization: Siren.LanguageType?) -> String {
        var path: String
        let table = "SirenLocalizable"
        if let forceLanguageLocalization = forceLanguageLocalization {
            path = sirenForcedBundlePath(forceLanguageLocalization: forceLanguageLocalization)
        } else {
            path = sirenBundlePath()
        }

        return Bundle(path: path)!.localizedString(forKey: stringKey, value: stringKey, table: table)
    }

    func bestMatchingAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

        return bundleDisplayName ?? bundleName ?? ""
    }
}

// MARK: - Bundle Extension for Testing Siren

extension Bundle {
    func testLocalizedString(stringKey: String, forceLanguageLocalization: Siren.LanguageType?) -> String {
        return Bundle().localizedString(stringKey: stringKey, forceLanguageLocalization: forceLanguageLocalization)
    }
}
