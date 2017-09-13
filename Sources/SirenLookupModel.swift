//
//  SirenLookupModel.swift
//  Siren
//
//  Created by Arthur Sabintsev on 8/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Model representing a selection of results from the iTunes Lookup API

struct SirenLookupModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }

    let results: [Results]

    struct Results: Decodable {
        private enum CodingKeys: String, CodingKey {
            case appID = "trackId"
            case currentVersionReleaseDate
            case minimumOSVersion = "minimumOsVersion"
            case version
        }

        let appID: Int
        let currentVersionReleaseDate: String
        let minimumOSVersion: String
        let version: String
    }
}
