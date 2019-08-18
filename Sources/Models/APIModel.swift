//
//  APIModel.swift
//  Siren
//
//  Created by Arthur Sabintsev on 8/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Model representing a selection of results from the iTunes Lookup API.
struct APIModel: Decodable {
    /// Codable Coding Keys for the Top-Level iTunes Lookup API JSON response.
    private enum CodingKeys: String, CodingKey {
        /// The results JSON key.
        case results
    }

    /// The array of results objects from the iTunes Lookup API.
    let results: [Results]

    /// The Results object from the the iTunes Lookup API.
    struct Results: Decodable {
        ///  Codable Coding Keys for the Results array in the iTunes Lookup API JSON response.
        private enum CodingKeys: String, CodingKey {
            /// The appID JSON key.
            case appID = "trackId"
            /// The current version release date JSON key.
            case currentVersionReleaseDate
            /// The minimum device iOS version compatibility JSON key.
            case minimumOSVersion = "minimumOsVersion"
            /// The release notes JSON key.
            case releaseNotes
            /// The current App Store version JSON key.
            case version
        }

        /// The app's App ID.
        let appID: Int

        /// The release date for the latest version of the app.
        let currentVersionReleaseDate: String

        /// The minimum version of iOS that the current version of the app requires.
        let minimumOSVersion: String

        /// The releases notes from the latest version of the app.
        let releaseNotes: String?

        /// The latest version of the app.
        let version: String
    }
}
