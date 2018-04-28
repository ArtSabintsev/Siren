//
//  SirenLookupModel.swift
//  Siren
//
//  Created by Arthur Sabintsev on 8/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Model representing a selection of results from the iTunes Lookup API

public struct SirenLookupModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }

    public let results: [Results]

    public struct Results: Decodable {
        private enum CodingKeys: String, CodingKey {
            case appID = "trackId"
            case currentVersionReleaseDate
            case minimumOSVersion = "minimumOsVersion"
            case releaseNotes
            case version
        }

        public let appID: Int
        public let currentVersionReleaseDate: String
        public let minimumOSVersion: String
        public let releaseNotes: String?
        public let version: String
    }
}
