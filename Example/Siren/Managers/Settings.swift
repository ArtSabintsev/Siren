//
//  Settings.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/24/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

public struct Settings {
    /// The name of your app.
    /// By default, it's set to the name of the app that's stored in your plist.
    var appName: String = Bundle.bestMatchingAppName()

    /// The region or country of an App Store in which your app is available.
    /// By default, all version check requests are performed against the US App Store.
    /// If your app is not available in the US App Store, set it to the identifier of at least one App Store region within which it is available.
    ///
    /// [List of country codes](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html)
    let countryCode: String?

    /// Overrides the default localization of a user's device when presenting the update message and button titles in the alert.
    /// See the Siren.LanguageType enum for more details.
    let forceLanguageLocalization: Localization.Language?

    public init(appName: String? = nil,
                countryCode: String? = nil,
                forceLanguageLocalization: Localization.Language? = nil) {
        self.countryCode = countryCode
        self.forceLanguageLocalization = forceLanguageLocalization

        if let appName = appName {
            self.appName = appName
        }
    }

    public static let `default` = Settings()
}
