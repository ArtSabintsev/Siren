//
//  Localization.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Localization information and strings for Siren.
public struct Localization {
    /// Determines the available languages in which the update message and alert button titles should appear.
    ///
    /// By default, the operating system's default lanuage setting is used. However, you can force a specific language
    /// by setting the forceLanguageLocalization property before calling checkVersion()
    public enum Language: String {
        /// Arabic Language Localization
        case arabic = "ar"
        /// Armenian Language Localization
        case armenian = "hy"
        /// Basque Language Localization
        case basque = "eu"
        /// Simplified Chinese Language Localization
        case chineseSimplified = "zh-Hans"
        /// Traditional Chinese Localization Localization
        case chineseTraditional = "zh-Hant"
        /// Croatian Language Localization
        case croatian = "hr"
        /// Czech Language Localization
        case czech = "cs"
        /// Danish Language Localization
        case danish = "da"
        /// Dutch Language Localization
        case dutch = "nl"
        /// English Language Localization
        case english = "en"
        /// Estonian Language Localization
        case estonian = "et"
        /// Finnish Language Localization
        case finnish = "fi"
        /// French Language Localization
        case french = "fr"
        /// German Language Localization
        case german = "de"
        /// Greek Language Localization
        case greek = "el"
        /// Hebrew Language Localization
        case hebrew = "he"
        /// Hungarian Language Localization
        case hungarian = "hu"
        /// Indonesian Language Localization
        case indonesian = "id"
        /// Italian Language Localization
        case italian = "it"
        /// Japanese Language Localization
        case japanese = "ja"
        /// Korean Language Localization
        case korean = "ko"
        /// Latvian Language Localization
        case latvian = "lv"
        /// Lithuanian Language Localization
        case lithuanian = "lt"
        /// Malay Language Localization
        case malay = "ms"
        /// Norwegian Language Localization
        case norwegian = "nb-NO"
        /// Persian Language Localization
        case persian = "fa"
        /// Persian (Afghanistan) Language Localization
        case persianAfghanistan = "fa-AF"
        /// Persian (Iran) Language Localization
        case persianIran = "fa-IR"
        /// Polish Language Localization
        case polish = "pl"
        /// Brazilian Portuguese Language Localization
        case portugueseBrazil = "pt"
        /// Portugal's Portuguese Language Localization
        case portuguesePortugal = "pt-PT"
        /// Romanian Language Localization
        case romanian = "ro"
        /// Russian Language Localization
        case russian = "ru"
        /// Serbian (Cyrillic) Language Localization
        case serbianCyrillic = "sr-Cyrl"
        /// Serbian (Latin) Language Localization
        case serbianLatin = "sr-Latn"
        /// Slovenian Language Localization
        case slovenian = "sl"
        /// Spanish Language Localization
        case spanish = "es"
        /// Swedish Language Localization
        case swedish = "sv"
        /// Thai Language Localization
        case thai = "th"
        /// Turkish Language Localization
        case turkish = "tr"
        /// Urdu Language Localization
        case urdu = "ur"
        /// Ukranian Language Localization
        case ukrainian = "uk"
        /// Vietnamese Language Localization
        case vietnamese = "vi"
    }

    /// The name of the app as defined by the `Info.plist`.
    private var appName: String = Bundle.bestMatchingAppName()

    /// Overrides the default localization of a user's device when presenting the update message and button titles in the alert.
    ///
    /// See the Siren.Localization.Language enum for more details.
    private let forceLanguage: Language?

    /// Initializes
    ///
    /// - Parameters:
    ///   - appName: Overrides the default name of the app. This is optional and defaults to the app that is defined in the `Info.plist`.
    ///   - forceLanguage: The language the alert to which the alert should be set. If `nil`, it falls back to the device's preferred locale.
    init(appName: String?, andForceLanguageLocalization forceLanguage: Language?) {
        if let appName = appName {
            self.appName = appName
        }

        self.forceLanguage = forceLanguage
    }

    /// The localized string for the `UIAlertController`'s message field.  .
    ///
    /// - Returns: A localized string for the update message.
    public func alertMessage(forCurrentAppStoreVersion currentAppStoreVersion: String) -> String {
        let message = Bundle.localizedString(forKey: AlertConstants.alertMessage,
                                             andForceLocalization: forceLanguage)

        return String(format: message, appName, currentAppStoreVersion)
    }

    /// The localized string for the `UIAlertController`'s title field.  .
    ///
    /// - Returns: A localized string for the phrase "Update Available".
    public func alertTitle() -> String {
        return Bundle.localizedString(forKey: AlertConstants.alertTitle,
                                      andForceLocalization: forceLanguage)
    }

    /// The localized string for the "Next time" `UIAlertAction`.
    ///
    /// - Returns: A localized string for the phrase "Next time".
    public func nextTimeButtonTitle() -> String {
        return Bundle.localizedString(forKey: AlertConstants.nextTimeButtonTitle,
                                      andForceLocalization: forceLanguage)
    }

    /// The localized string for the "Skip this version" `UIAlertAction`.
    ///
    /// - Returns: A localized string for the phrase "Skip this version".
    public func skipButtonTitle() -> String {
        return Bundle.localizedString(forKey: AlertConstants.skipButtonTitle,
                                      andForceLocalization: forceLanguage)
    }

    /// The localized string for the "Update" `UIAlertAction`.
    ///
    /// - Returns: A localized string for the phrase "Update".
    public func updateButtonTitle() -> String {
        return Bundle.localizedString(forKey: AlertConstants.updateButtonTitle,
                                      andForceLocalization: forceLanguage)
    }
}
