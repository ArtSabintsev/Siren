//
//  Constants.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Lists all enumerated types that are used to configure the library.
public struct Constants {
    /// Determines the type of alert to present after a successful version check has been performed.
    public enum AlertType {
        /// Forces user to update your app (1 button alert).
        case force
        /// (DEFAULT) Presents user with option to update app now or at next launch (2 button alert).
        case option
        /// Presents user with option to update the app now, at next launch, or to skip this version all together (3 button alert).
        case skip
        /// Doesn't show the alert, but instead returns a localized message
        /// for use in a custom UI within the sirenDidDetectNewVersionWithoutAlert() delegate method.
        case none
    }

    /// `UpdateType` defines what kind of update is available.
    /// It is used as a parameter if the user wants to use
    /// a custom alert to inform the user about an update.
    ///
    /// - major: Major release available: A.b.c.d
    /// - minor: Minor release available: a.B.c.d
    /// - patch: Patch release available: a.b.C.d
    /// - revision: Revision release available: a.b.c.D
    /// - unknown: No information available about the update.
    public enum UpdateType: String {
        /// Major release available: A.b.c.d
        case major
        /// Minor release available: a.B.c.d
        case minor
        /// Patch release available: a.b.C.d
        case patch
        /// Revision release available: a.b.c.D
        case revision
        /// No information available about the update.
        case unknown
    }

    /// Determines the frequency in which the the version check is performed and the user is prompted to update the app.
    public enum VersionCheckFrequency: Int {
        /// Version check performed every time the app is launched.
        case immediately = 0
        /// Version check performed once a day.
        case daily = 1
        /// Version check performed once a week.
        case weekly = 7
    }
}
