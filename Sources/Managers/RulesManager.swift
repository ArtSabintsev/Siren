//
//  RulesManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/1/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// RulesManager for Siren
public struct RulesManager {
    /// The alert will only show up if the current version has already been released for X days.
    ///
    /// This value defaults to 1 day (in `RulesManager`'s initializer) to avoid an issue where
    /// Apple updates the JSON faster than the app binary propogates to the App Store.
    let releasedForDays: Int

    /// The `Rules` that should be used when the App Store version of the app signifies that it is a **major** version update (A.b.c.d).
    var majorUpdateRules: Rules

    /// The `Rules` that should be used when the App Store version of the app signifies that it is a **minor** version update (a.B.c.d).
    var minorUpdateRules: Rules

    /// The `Rules` that should be used when the App Store version of the app signifies that it is a **patch** version update (a.b.C.d).
    var patchUpdateRules: Rules

    /// The `Rules` that should be used when the App Store version of the app signifies that it is a **revision** version update (a.b.c.D).
    var revisionUpdateRules: Rules

    /// Initializer that sets update-specific `Rules` for all updates (e.g., major, minor, patch, revision).
    /// This means that each of the four update types can have their own specific update rules.
    ///
    /// By default, the `releasedForDays` parameter delays the update alert from being presented for _1 day_
    /// to avoid an issue where the _iTunes Lookup_ API response is updated faster than the time it takes for the binary
    /// to become available on App Store CDNs across all regions. Usually it takes 6-24 hours, hence the _1 day_ delay.
    ///
    /// - Warning: Setting `releasedForDays` to _0 days_ causes the alert to appear right away, even if the binary isn't available.
    /// If this value is set to _0 days_, and an `AlertType` of type `.force` is set, it will cause your app to infinitely send the
    /// end-user to the App Store to download a version that's not there and lock them out of your application until the binary is
    /// is available to be downloaded.
    ///
    /// - Parameters:
    ///   - rules: The rules that should be set for all version updates.
    ///   - releasedForDays: The amount of time (in days) that the app should delay before presenting the user
    public init(majorUpdateRules: Rules = .default,
                minorUpdateRules: Rules = .default,
                patchUpdateRules: Rules = .default,
                revisionUpdateRules: Rules = .default,
                showAlertAfterCurrentVersionHasBeenReleasedForDays releasedForDays: Int = 1) {
        self.majorUpdateRules = majorUpdateRules
        self.minorUpdateRules = minorUpdateRules
        self.patchUpdateRules = patchUpdateRules
        self.revisionUpdateRules = revisionUpdateRules
        self.releasedForDays = releasedForDays
    }

    /// Initializer that sets the same update `Rules` for all types of updates (e.g., major, minor, patch, revision).
    /// This means that all four update types will use the same presentation rules.
    ///
    /// By default, the `releasedForDays` parameter delays the update alert from being presented for _1 day_
    /// to avoid an issue where the _iTunes Lookup_ API response is updated faster than the time it takes for the binary
    /// to become available on App Store CDNs across all regions. Usually it takes 6-24 hours, hence the _1 day_ delay.
    ///
    /// - Warning: Setting `releasedForDays` to _0 days_ causes the alert to appear right away, even if the binary isn't available.
    /// If this value is set to _0 days_, and an `AlertType` of type `.force` is set, it will cause your app to infinitely send the
    /// end-user to the App Store to download a version that's not there and lock them out of your application until the binary is
    /// is available to be downloaded.
    ///
    /// - Parameters:
    ///   - rules: The rules that should be set for all version updates.
    ///   - releasedForDays: The amount of time (in days) that the app should delay before presenting the user
    public init(globalRules rules: Rules = .default,
                showAlertAfterCurrentVersionHasBeenReleasedForDays releasedForDays: Int = 1) {
        self.init(majorUpdateRules: rules,
                  minorUpdateRules: rules,
                  patchUpdateRules: rules,
                  revisionUpdateRules: rules,
                  showAlertAfterCurrentVersionHasBeenReleasedForDays: releasedForDays)
    }

    /// Returns the appropriate update rules based on the type of version that is returned from the API.
    ///
    /// - Parameters: type: The type of app update.
    /// - Throws: The `noUpdateAvailable` error since this is the only way a valie of `unknown` can occur.
    /// - Returns: The appropriate rule based on the type of app update that is returned by the API.
    func loadRulesForUpdateType(_ type: UpdateType) throws -> Rules {
        switch type {
        case .major: return majorUpdateRules
        case .minor: return minorUpdateRules
        case .patch: return patchUpdateRules
        case .revision: return revisionUpdateRules
        case .unknown: throw KnownError.noUpdateAvailable
        }
    }

    /// The default `RulesManager`.
    ///
    /// By default, the `Rules.default` rule is used for all update typs.
    public static let `default` = RulesManager(globalRules: .default)
}

// MARK: - RulesManager-related Constants

extension RulesManager {
    /// Informs Siren of the type of update that is available so that
    /// the appropriate ruleset is used to present the update alert.
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
}
