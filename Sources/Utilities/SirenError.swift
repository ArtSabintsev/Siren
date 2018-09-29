//
//  SirenError.swift
//  Siren
//
//  Created by Arthur Sabintsev on 8/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Siren Error Handling

/// Data structure used to build Siren specific Errors.
public struct SirenError: LocalizedError {
    /// Enumerates all potentials errors that Siren can handle.
    ///
    /// - appStoreAppIDFailure: Error retrieving trackId as the JSON does not contain a 'trackId' key.
    /// - appStoreDataRetrievalFailure: Error retrieving App Store data as an error was returned.
    /// - appStoreJSONParsingFailure: Error parsing App Store JSON data.
    /// - appStoreDataRetrievalEmptyResults: Error retrieving App Store data as JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error.
    /// - appStoreOSVersionNumberFailure: Error retrieving iOS version number as there was no data returned.
    /// - appStoreOSVersionUnsupported: The version of iOS on the device is lower than that of the one required by the app verison update.
    /// - appStoreVersionArrayFailure: Error retrieving App Store verson number as the JSON does not contain a 'version' key.
    /// - malformedURL: The iTunes URL is malformed. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible.
    /// - noUpdateAvailable: No new update available.
    /// - recentlyCheckedAlready: Not checking the version, because it was already checked recently.
    public enum Known: Error {
        /// Error retrieving trackId as the JSON does not contain a 'trackId' key.
        case appStoreAppIDFailure
        /// Error retrieving App Store data as an error was returned.
        case appStoreDataRetrievalFailure(underlyingError: Error?)
        /// Error parsing App Store JSON data.
        case appStoreJSONParsingFailure(underlyingError: Error)
        /// Error retrieving App Store data as JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error.
        case appStoreDataRetrievalEmptyResults
        /// Error retrieving iOS version number as there was no data returned.
        case appStoreOSVersionNumberFailure
        /// The version of iOS on the device is lower than that of the one required by the app verison update.
        case appStoreOSVersionUnsupported
        /// Error retrieving App Store verson number as the JSON does not contain a 'version' key.
        case appStoreVersionArrayFailure
        /// The iTunes URL is malformed. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible.
        case malformedURL
        /// No new update available.
        case noUpdateAvailable
        /// Not checking the version, because it was already checked recently.
        case recentlyCheckedAlready

        /// The localized description for each error handled by Siren.
        var localizedDescription: String {
            switch self {
            case .appStoreAppIDFailure:
                return "Error retrieving trackId as the JSON does not contain a 'trackId' key."
            case .appStoreDataRetrievalFailure(let error?):
                return "Error retrieving App Store data as an error was returned\nAlso, the following system level error was returned: \(error)"
            case .appStoreDataRetrievalFailure(.none):
                return "Error retrieving App Store data as an error was returned."
            case .appStoreDataRetrievalEmptyResults:
                return "Error retrieving App Store data as the JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error."
            case .appStoreJSONParsingFailure(let error):
                return "Error parsing App Store JSON data.\nAlso, the following system level error was returned: \(error)"
            case .appStoreOSVersionNumberFailure:
                return "Error retrieving iOS version number as there was no data returned."
            case .appStoreOSVersionUnsupported:
                return "The version of iOS on the device is lower than that of the one required by the app verison update."
            case .appStoreVersionArrayFailure:
                return "Error retrieving App Store verson number as the JSON does not contain a 'version' key."
            case .malformedURL:
                return "The iTunes URL is malformed. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible."
            case .noUpdateAvailable:
                return "No new update available."
            case .recentlyCheckedAlready:
                return "Not checking the version, because it was already checked recently."
            }
        }
    }
}

// MARK: - Error Handling

extension Siren {
    func postError(_ error: SirenError.Known) {
        delegate?.sirenDidFailVersionCheck(error: error)
        printMessage(error.localizedDescription)
    }
}
