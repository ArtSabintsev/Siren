//
//  APIManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/24/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

public struct APIManager {
    /// The region or country of an App Store in which your app is available.
    /// By default, all version check requests are performed against the US App Store.
    /// If your app is not available in the US App Store, set it to the identifier of at least one App Store region within which it is available.
    ///
    /// [List of country codes](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html)
    let countryCode: String?

    public init(countryCode: String? = nil) {
        self.countryCode = countryCode
    }

    public static let `default` = APIManager()
}
