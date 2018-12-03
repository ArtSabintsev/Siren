//
//  KnownError.swift
//  Siren
//
//  Created by Arthur Sabintsev on 8/6/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Enumerates all potentials errors that Siren can handle.
public enum KnownError: LocalizedError {
    /// Error retrieving trackId as the JSON does not contain a 'trackId' key.
    case appStoreAppIDFailure
    /// Error retrieving App Store data as an error was returned.
    case appStoreDataRetrievalFailure(underlyingError: Error?)
    /// Error parsing App Store JSON data.
    case appStoreJSONParsingFailure(underlyingError: Error)
    /// Error retrieving App Store data as JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error.
    case appStoreDataRetrievalEmptyResults
    /// The version of iOS on the device is lower than that of the one required by the app verison update.
    case appStoreOSVersionUnsupported
    /// Error retrieving App Store verson number as the JSON does not contain a `version` key.
    case appStoreVersionArrayFailure
    /// The iTunes URL is malformed. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible.
    case malformedURL
    /// Please make sure that you have set a `Bundle Identifier` in your project.
    case missingBundleID
    /// No new update available.
    case noUpdateAvailable
    /// Siren will not perform a version check as it performed one too recently. If you would like to perform a version check every time Siren is called, please consider using the `VersionCheckFrequency.immediately` within the `RulesManager.`
    case recentlyCheckedVersion
    /// The app has been released for X days, but Siren cannot prompt the user until Y (where Y > X) days have passed.
    case releasedTooSoon(daysSinceRelease: Int, releasedForDays: Int)

    /// The localized description for each error handled by Siren.
    public var localizedDescription: String {
        switch self {
        case .appStoreAppIDFailure:
            return "[Siren Error]: Error retrieving trackId as the JSON does not contain a `trackId` key."
        case .appStoreDataRetrievalFailure(let error?):
            return "[Siren Error]: Error retrieving App Store data as an error was returned\nAlso, the following system level error was returned: \(error)"
        case .appStoreDataRetrievalFailure(.none):
            return "[Siren Error]: Error retrieving App Store data as an error was returned."
        case .appStoreDataRetrievalEmptyResults:
            return "[Siren Error]: Error retrieving App Store data as the JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error."
        case .appStoreJSONParsingFailure(let error):
            return "[Siren Error]: Error parsing App Store JSON data.\nAlso, the following system level error was returned: \(error)"
        case .appStoreOSVersionUnsupported:
            return "[Siren Error]: The version of iOS on the device is lower than that of the one required by the app verison update."
        case .appStoreVersionArrayFailure:
            return "[Siren Error]: Error retrieving App Store verson number as the JSON does not contain a `version` key."
        case .malformedURL:
            return "[Siren Error]: The iTunes URL is malformed. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible."
        case .missingBundleID:
            return "[Siren Error]: Please make sure that you have set a `Bundle Identifier` in your project."
        case .noUpdateAvailable:
            return "[Siren Error]: No new update available."
        case .recentlyCheckedVersion:
            return "[Siren Error]: Siren will not perform a version check as it performed one too recently. If you would like to perform a version check every time Siren is called, please consider using the `VersionCheckFrequency.immediately` within the `RulesManager.`"
        case .releasedTooSoon(let daysSinceRelease, let releasedForDays):
            return "[Siren Error]: The app has been released for \(daysSinceRelease) days, but Siren cannot prompt the user until \(releasedForDays) days have passed."
        }
    }
}
