//
//  Model.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/27/19.
//  Copyright © 2019 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// The validated and unwrapped `APIModel`.
/// This model is presented to the end user in Siren's completion handler.
public struct Model {
    /// The app's App ID.
    public let appID: Int

    /// The release date for the latest version of the app.
    public let currentVersionReleaseDate: String

    /// The minimum version of iOS that the current version of the app requires.
    public let minimumOSVersion: String

    /// The releases notes from the latest version of the app.
    public let releaseNotes: String?

    /// The latest version of the app.
    public let version: String

    /// The initializer for the `public` facing Model type.
    ///
    /// - Parameters:
    ///   - appID: The app's App ID.
    ///   - currentVersionReleaseDate: The release date for the latest version of the app.
    ///   - minimumOSVersion: The minimum version of iOS that the current version of the app requires.
    ///   - releaseNotes: The releases notes from the latest version of the app.
    ///   - version: The latest version of the app.
    init(appID: Int,
         currentVersionReleaseDate: String,
         minimumOSVersion: String,
         releaseNotes: String?,
         version: String) {
        self.appID = appID
        self.currentVersionReleaseDate = currentVersionReleaseDate
        self.minimumOSVersion = minimumOSVersion
        self.releaseNotes = releaseNotes
        self.version = version
    }
}
