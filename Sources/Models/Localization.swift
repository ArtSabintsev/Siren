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

    private let presentationManager: PresentationManager
    private let version: String?

    init(presentationManager: PresentationManager, forCurrentAppStoreVersion version: String?) {
        self.presentationManager = presentationManager
        self.version = version
    }

    public func alertMessage() -> String {
        let message = Bundle.localizedString(forKey: PresentationManager.Constants.alertMessage.string,
                                             andForceLocalization: presentationManager.forceLanguageLocalization)

        guard let version = version else {
            return String(format: message, presentationManager.appName, "Unknown")
        }

        return String(format: message, presentationManager.appName, version)
    }

    public func alertTitle() -> String {
        return Bundle.localizedString(forKey: PresentationManager.Constants.alertTitle.string,
                                      andForceLocalization: presentationManager.forceLanguageLocalization)
    }

    public func nextTimeButtonTitle() -> String {
        return Bundle.localizedString(forKey: PresentationManager.Constants.nextTimeButtonTitle.string,
                                      andForceLocalization: presentationManager.forceLanguageLocalization)
    }

    public func skipButtonTitle() -> String {
        return Bundle.localizedString(forKey: PresentationManager.Constants.skipButtonTitle.string,
                                      andForceLocalization: presentationManager.forceLanguageLocalization)
    }

    public func updateButtonTitle() -> String {
        return Bundle.localizedString(forKey: PresentationManager.Constants.updateButtonTitle.string,
                                      andForceLocalization: presentationManager.forceLanguageLocalization)
    }
}
