//
//  APIManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/24/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// APIManager for Siren
public struct APIManager {
    /// The region or country of an App Store in which the app is available.
    /// By default, all version check requests are performed against the US App Store.
    /// If the app is not available in the US App Store, set it to the identifier of at least one App Store region within which it is available.
    ///
    /// [List of country codes](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html)
    ///
    let countryCode: String?

    /// Initializes `APIManager` to the region or country of an App Store in which the app is available.
    /// By default, all version check requests are performed against the US App Store.
    /// If the app is not available in the US App Store, set it to the identifier of at least one App Store region within which it is available.
    ///
    /// [List of country codes](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html)
    ///
    /// - Parameter countryCode: The country code for the App Store in which the app is availabe.
    public init(countryCode: String? = nil) {
        self.countryCode = countryCode
    }

    /// The default `APIManager`.
    ///
    /// The version check is performed against the  US App Store.
    public static let `default` = APIManager()
}
