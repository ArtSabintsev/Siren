//
//  Localization.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Localization Helpers for Siren

/// Localization information for Siren
public struct Localization {
    /// Determines the available languages in which the update message and alert button titles should appear.
    ///
    /// By default, the operating system's default lanuage setting is used. However, you can force a specific language
    /// by setting the forceLanguageLocalization property before calling checkVersion()
    public enum Language: String {
        /// Arabic
        case arabic = "ar"
        /// Armenian
        case armenian = "hy"
        /// Basque
        case basque = "eu"
        /// Simplified Chinese
        case chineseSimplified = "zh-Hans"
        /// Traditional Chinese
        case chineseTraditional = "zh-Hant"
        /// Croatian
        case croatian = "hr"
        /// Czech
        case czech = "cs"
        /// Danish
        case danish = "da"
        /// Dutch
        case dutch = "nl"
        /// English
        case english = "en"
        /// Estonian
        case estonian = "et"
        /// Finnish
        case finnish = "fi"
        /// French
        case french = "fr"
        /// German
        case german = "de"
        /// Greek
        case greek = "el"
        /// Hebrew
        case hebrew = "he"
        /// Hungarian
        case hungarian = "hu"
        /// Indonesian
        case indonesian = "id"
        /// Italian
        case italian = "it"
        /// Japanese
        case japanese = "ja"
        /// Korean
        case korean = "ko"
        /// Latvian
        case latvian = "lv"
        /// Lithuanian
        case lithuanian = "lt"
        /// Malaysian
        case malay = "ms"
        /// Norwegian
        case norwegian = "nb-NO"
        /// Persian
        case persian = "fa"
        /// Persian (Afghanistan)
        case persianAfghanistan = "fa-AF"
        /// Persian (Iran)
        case persianIran = "fa-IR"
        /// Polish
        case polish = "pl"
        /// Portuguese (Brazil)
        case portugueseBrazil = "pt"
        /// Portuguese (Portugal)
        case portuguesePortugal = "pt-PT"
        /// Russian
        case russian = "ru"
        /// Serbian (Cyrillic)
        case serbianCyrillic = "sr-Cyrl"
        /// Serbian (Latin)
        case serbianLatin = "sr-Latn"
        /// Slovenian
        case slovenian = "sl"
        /// Spanish
        case spanish = "es"
        /// Swedish
        case swedish = "sv"
        /// Thai
        case thai = "th"
        /// Turkish
        case turkish = "tr"
        /// Urdu
        case urdu = "ur"
        /// Ukranian
        case ukrainian = "uk"
        /// Vietnamese
        case vietnamese = "vi"
    }

    private var appName: String
    private var language: Localization.Language?
    private var version: String?

    init(forceLanguageLocalization language: Localization.Language?,
         forAppName appName: String,
         forCurrentAppStoreVersion version: String?) {
        self.appName = appName
        self.language = language
        self.version = version
    }

    func alertMessage() -> String {
        let message = Bundle.localizedString(forKey: AlertMessaging.Constants.alertMessage.string,
                                             andForceLanguageLocalization: language)

        guard let version = version else {
            return String(format: message, appName, "Unknown")
        }

        return String(format: message, appName, version)
    }

    func alertTitle() -> String {
        return Bundle.localizedString(forKey: AlertMessaging.Constants.alertTitle.string,
                                      andForceLanguageLocalization: language)
    }

    func nextTimeButtonTitle() -> String {
        return Bundle.localizedString(forKey: AlertMessaging.Constants.nextTimeButtonTitle.string,
                                      andForceLanguageLocalization: language)
    }

    func skipButtonTitle() -> String {
        return Bundle.localizedString(forKey: AlertMessaging.Constants.skipButtonTitle.string,
                                      andForceLanguageLocalization: language)
    }

    func updateButtonTitle() -> String {
        return Bundle.localizedString(forKey: AlertMessaging.Constants.updateButtonTitle.string,
                                      andForceLanguageLocalization: language)
    }
}
