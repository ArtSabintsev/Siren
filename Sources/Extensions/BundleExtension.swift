//
//  BundleExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// `Bundle` Extension for Siren.
extension Bundle {
    /// Constants used in the `Bundle` extension.
    struct Constants {
        /// Constant for the `.bundle` file extension.
        static let bundleExtension = "bundle"
        /// Constant for `CFBundleDisplayName`.
        static let displayName = "CFBundleDisplayName"
        /// Constant for the default US English localization.
        static let englishLocalization = "en"
        /// Constant for the project file extension.
        static let projectExtension = "lproj"
        /// Constant for `CFBundleShortVersionString`.
        static let shortVersionString = "CFBundleShortVersionString"
        /// Constant for the localization table.
        static let table = "SirenLocalizable"
    }

    /// Fetches the current version of the app.
    ///
    /// - Returns: The current installed version of the app.
    final class func version() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: Constants.shortVersionString) as? String
    }

    /// Returns the localized string for a given default string.
    ///
    /// By default, the English language localization is used.
    /// If the device's localization is set to another locale, that local's language is used if it's supported by Siren.
    /// If `forcedLanguage` is set to `true`, the chosen language is shown for all devices, irrespective of their device's localization.
    ///
    ///
    /// - Parameters:
    ///   - key: The default string used to search the localization table for a specific translation.
    ///   - forcedLanguage: Returns
    /// - Returns: The localized string for a given key.
    final class func localizedString(forKey key: String, andForceLocalization forcedLanguage: Localization.Language?) -> String {
        guard var path = sirenBundlePath() else {
            return key
        }

        if let deviceLangauge = deviceLanguage(),
            let devicePath = sirenForcedBundlePath(forceLanguageLocalization: deviceLangauge) {
            path = devicePath
        }

        if let forcedLanguage = forcedLanguage,
            let forcedPath = sirenForcedBundlePath(forceLanguageLocalization: forcedLanguage) {
            path = forcedPath
        }

        return Bundle(path: path)?.localizedString(forKey: key, value: key, table: Constants.table) ?? key
    }

    /// The appropriate name for the app to be displayed in the update alert.
    ///
    /// Siren checks `CFBundleDisplayName` first. It then falls back to
    /// to `kCFBundleNameKey` and ultimately to an empty string
    /// if the aforementioned values are nil.
    ///
    /// - Returns: The name of the app.
    final class func bestMatchingAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: Constants.displayName) as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String

        return bundleDisplayName ?? bundleName ?? ""
    }
}

private extension Bundle {
    /// The path to Siren's localization `Bundle`.
    ///
    /// - Returns: The bundle's path or `nil`.
    final class func sirenBundlePath() -> String? {
        #if SWIFT_PACKAGE
        return Bundle.module.path(forResource: "\(Siren.self)", ofType: Constants.bundleExtension)
        #else
        return Bundle(for: Siren.self).path(forResource: "\(Siren.self)", ofType: Constants.bundleExtension)
        #endif
    }

    /// The path for a particular language localizationin Siren's localization `Bundle`.
    ///
    /// - Parameter forceLanguageLocalization: The language localization that should be searched for in Siren's localization `bundle`.
    /// - Returns: The path to the forced language localization.
    final class func sirenForcedBundlePath(forceLanguageLocalization: Localization.Language) -> String? {
        guard let path = sirenBundlePath() else { return nil }
        let name = forceLanguageLocalization.rawValue

        return Bundle(path: path)?.path(forResource: name, ofType: Constants.projectExtension)
    }

    /// The user's preferred language based on their device's localization.
    ///
    /// - Returns: The user's preferred language.
    final class func deviceLanguage() -> Localization.Language? {
        guard let preferredLocalization = Bundle.main.preferredLocalizations.first,
            preferredLocalization != Constants.englishLocalization,
            let preferredLanguage = Localization.Language(rawValue: preferredLocalization) else {
                return nil
        }

        return preferredLanguage
    }
}
