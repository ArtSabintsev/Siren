//
//  SirenLookupModel.swift
//  Siren
//
//  Created by Arthur Sabintsev on 8/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Model representing a selection of results from the iTunes Lookup API

/// MARK: Siren extension used to parse and map the iTunes JSON results into a model represented in Swift.
public struct SirenLookupModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }

    /// The array of results objects from the iTunes Lookup API.
    public let results: [Results]

    /// The Results object from the the iTunes Lookup API.
    public struct Results: Decodable {
        private enum CodingKeys: String, CodingKey {
            case appID = "trackId"
            case currentVersionReleaseDate
            case minimumOSVersion = "minimumOsVersion"
            case releaseNotes
            case version
        }

        /// The app's App ID.
        public let appID: Int

        /// The release date for the latest verison of the app.
        public let currentVersionReleaseDate: String

        /// The minimum verison of iOS that the current verison of the app requires.
        public let minimumOSVersion: String

        /// The releases notes from the latest version of the app.
        public let releaseNotes: String?

        /// The latest version of the app.
        public let version: String
    }
}
