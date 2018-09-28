//
//  SirenConstants.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Enumerated Types

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
        case arabic = "ar"
        case armenian = "hy"
        case basque = "eu"
        case chineseSimplified = "zh-Hans"
        case chineseTraditional = "zh-Hant"
        case croatian = "hr"
        case czech = "cs"
        case danish = "da"
        case dutch = "nl"
        case english = "en"
        case estonian = "et"
        case finnish = "fi"
        case french = "fr"
        case german = "de"
        case greek = "el"
        case hebrew = "he"
        case hungarian = "hu"
        case indonesian = "id"
        case italian = "it"
        case japanese = "ja"
        case korean = "ko"
        case latvian = "lv"
        case lithuanian = "lt"
        case malay = "ms"
        case norwegian = "nb-NO"
        case persian = "fa"
        case persianAfghanistan = "fa-AF"
        case persianIran = "fa-IR"
        case polish = "pl"
        case portugueseBrazil = "pt"
        case portuguesePortugal = "pt-PT"
        case russian = "ru"
        case serbianCyrillic = "sr-Cyrl"
        case serbianLatin = "sr-Latn"
        case slovenian = "sl"
        case spanish = "es"
        case swedish = "sv"
        case thai = "th"
        case turkish = "tr"
        case urdu = "ur"
        case ukrainian = "uk"
        case vietnamese = "vi"
    }
}
