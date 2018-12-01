//
//  RulesManager.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/1/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

public struct RulesManager {
    /// When this is set, the alert will only show up if the current version has already been released for X days.
    /// Defaults to 1 day (in the initializer) to avoid an issue where Apple updates the JSON faster than the app binary propogates to the App Store.
    let releasedForDays: Int

    var majorUpdateRules: Rules
    var minorUpdateRules: Rules
    var patchUpdateRules: Rules
    var revisionUpdateRules: Rules

    public init(globalRules rules: Rules,
                showAlertAfterCurrentVersionHasBeenReleasedForDays releasedForDays: Int = 1) {
        majorUpdateRules = rules
        minorUpdateRules = rules
        patchUpdateRules = rules
        revisionUpdateRules = rules
        self.releasedForDays = releasedForDays
    }

    public init(majorUpdateRules: Rules,
                minorUpdateRules: Rules,
                patchUpdateRules: Rules,
                revisionUpdateRules: Rules,
                showAlertAfterCurrentVersionHasBeenReleasedForDays releasedForDays: Int = 1) {
        self.majorUpdateRules = majorUpdateRules
        self.minorUpdateRules = minorUpdateRules
        self.patchUpdateRules = patchUpdateRules
        self.revisionUpdateRules = revisionUpdateRules
        self.releasedForDays = releasedForDays
    }

    func loadRulesForUpdateType(_ type: UpdateType) -> Rules {
        switch type {
        case .major: return majorUpdateRules
        case .minor: return minorUpdateRules
        case .patch: return patchUpdateRules
        case .revision: return revisionUpdateRules
        case .unknown: return majorUpdateRules
        }
    }

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
