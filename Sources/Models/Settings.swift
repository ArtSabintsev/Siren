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
    let appName: String

    /// The region or country of an App Store in which your app is available.
    /// By default, all version checks are performed against the US App Store.
    /// If your app is not available in the US App Store, set it to the identifier of at least one App Store within which it is available.
    let countryCode: String?

    /// Overrides the default localization of a user's device when presenting the update message and button titles in the alert.
    /// See the Siren.LanguageType enum for more details.
    let forceLanguageLocalization: Localization.Language?

    public init(appName: String? = nil,
                countryCode: String? = nil,
                forceLanguageLocalization: Localization.Language? = nil) {
        self.appName = appName ?? Bundle.bestMatchingAppName()
        self.countryCode = countryCode
        self.forceLanguageLocalization = forceLanguageLocalization
    }

}
