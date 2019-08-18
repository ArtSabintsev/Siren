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
    /// Error retrieving App Store data as JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error.
    case appStoreDataRetrievalEmptyResults
    /// Error retrieving App Store data as an error was returned.
    case appStoreDataRetrievalFailure(underlyingError: Error?)
    /// Error parsing App Store JSON data.
    case appStoreJSONParsingFailure(underlyingError: Error)
    /// The version of iOS on the device is lower than that of the one required by the app version update.
    case appStoreOSVersionUnsupported
    /// Error retrieving App Store verson number as the JSON does not contain a `version` key.
    case appStoreVersionArrayFailure
    /// The `currentVersionReleaseDate` key is missing in the JSON payload. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible.
    case currentVersionReleaseDate
    /// One of the iTunes URLs used in Siren is malformed. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible.
    case malformedURL
    /// Please make sure that you have set a `Bundle Identifier` in your project.
    case missingBundleID
    /// No new update available.
    case noUpdateAvailable
    /// Siren will not present an update alert if it performed one too recently. If you would like to present an alert every time Siren is called, please consider setting the `UpdatePromptFrequency.immediately` rule in `RulesManager`
    case recentlyPrompted
    /// The app has been released for X days, but Siren cannot prompt the user until Y (where Y > X) days have passed.
    case releasedTooSoon(daysSinceRelease: Int, releasedForDays: Int)
    /// The user has opted to skip updating their current version of the app to the current App Store version.
    case skipVersionUpdate(installedVersion: String, appStoreVersion: String)

    /// The localized description for each error handled by Siren.
    public var localizedDescription: String {
        switch self {
        case .appStoreAppIDFailure:
            return "\(KnownError.sirenError) Error retrieving trackId as the JSON does not contain a `trackId` key."
        case .appStoreDataRetrievalFailure(let error?):
            return "\(KnownError.sirenError) Error retrieving App Store data as an error was returned\nAlso, the following system level error was returned: \(error)"
        case .appStoreDataRetrievalEmptyResults:
            return "\(KnownError.sirenError) Error retrieving App Store data as the JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error."
        case .appStoreDataRetrievalFailure(.none):
            return "\(KnownError.sirenError) Error retrieving App Store data as an error was returned."
        case .appStoreJSONParsingFailure(let error):
            return "\(KnownError.sirenError) Error parsing App Store JSON data.\nAlso, the following system level error was returned: \(error)"
        case .appStoreOSVersionUnsupported:
            return "\(KnownError.sirenError) The version of iOS on the device is lower than that of the one required by the app version update."
        case .appStoreVersionArrayFailure:
            return "\(KnownError.sirenError) Error retrieving App Store verson number as the JSON does not contain a `version` key."
        case .currentVersionReleaseDate:
            return "\(KnownError.sirenError) The `currentVersionReleaseDate` key is missing in the JSON payload. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible."
        case .malformedURL:
            return "\(KnownError.sirenError) One of the iTunes URLs used in Siren is malformed. Please leave an issue on https://github.com/ArtSabintsev/Siren with as many details as possible."
        case .missingBundleID:
            return "\(KnownError.sirenError) Please make sure that you have set a `Bundle Identifier` in your project."
        case .noUpdateAvailable:
            return "\(KnownError.sirenError) No new update available."
        case .recentlyPrompted:
            return "\(KnownError.sirenError) Siren will not present an update alert if it performed one too recently. If you would like to present an alert every time Siren is called, please consider setting the `\(Rules.UpdatePromptFrequency.self).immediately` rule in `\(RulesManager.self)`"
        case .releasedTooSoon(let daysSinceRelease, let releasedForDays):
            return "\(KnownError.sirenError) The app has been released for \(daysSinceRelease) days, but Siren cannot prompt the user until \(releasedForDays) days have passed."
        case .skipVersionUpdate(let installedVersion, let appStoreVersion):
            return "\(KnownError.sirenError) The user has opted to skip updating their current version of the app (\(installedVersion)) to the current App Store version (\(appStoreVersion))."
        }
    }

    /// An easily identifiable prefix for all errors thrown by Siren.
    private static var sirenError: String {
        return "[Siren Error]"
    }
}
