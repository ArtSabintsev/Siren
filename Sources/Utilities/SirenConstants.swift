//
//  SirenConstants.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Enumerated Types

// MARK: Siren extension dealing with enumerated types and constants.
public extension Siren {
    /// Determines the type of alert to present after a successful version check has been performed.
    enum AlertType {
        /// Forces user to update your app (1 button alert).
        case force
        /// (DEFAULT) Presents user with option to update app now or at next launch (2 button alert).
        case option
        /// Presents user with option to update the app now, at next launch, or to skip this version all together (3 button alert).
        case skip
        /// Doesn't show the alert, but instead returns a localized message
        /// for use in a custom UI within the sirenDidDetectNewVersionWithoutAlert() delegate method.
        case none
    }

    /// Determines the frequency in which the the version check is performed and the user is prompted to update the app.
    ///
    enum VersionCheckType: Int {
        /// Version check performed every time the app is launched.
        case immediately = 0
        /// Version check performed once a day.
        case daily = 1
        /// Version check performed once a week.
        case weekly = 7
    }

    /// Determines the available languages in which the update message and alert button titles should appear.
    ///
    /// By default, the operating system's default lanuage setting is used. However, you can force a specific language
    /// by setting the forceLanguageLocalization property before calling checkVersion()
    enum LanguageType: String {
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
}
