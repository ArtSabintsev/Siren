//
//  SirenDelegate.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 4/8/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - SirenDelegate Protocol

/// Delegate that handles all codepaths for Siren upon version check completion.
public protocol SirenDelegate: class {
    /// User presented with update dialog.
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType)

    /// User did click on button that launched App Store.app.
    func sirenUserDidLaunchAppStore()

    /// User did click on button that skips version update.
    func sirenUserDidSkipVersion()

    /// User did click on button that cancels update dialog.
    func sirenUserDidCancel()

    /// Siren failed to perform version check (may return system-level error).
    func sirenDidFailVersionCheck(error: NSError)

    /// Siren performed version check and did not display alert.
    func sirenDidDetectNewVersionWithoutAlert(message: String)

    /// Siren performed version check and latest version is installed.
    func sirenLatestVersionInstalled()
}

// MARK: - SirenDelegate Protocol Extension

public extension SirenDelegate {

    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        assertionFailure("An attempt to reach \(#function) failed as it was called without being implemented.")
    }

    func sirenUserDidLaunchAppStore() {
        assertionFailure("An attempt to reach \(#function) failed as it was called without being implemented.")
    }

    func sirenUserDidSkipVersion() {
        assertionFailure("An attempt to reach \(#function) failed as it was called without being implemented.")
    }

    func sirenUserDidCancel() {
        assertionFailure("An attempt to reach \(#function) failed as it was called without being implemented.")
    }

    func sirenDidFailVersionCheck(error: NSError) {
        assertionFailure("An attempt to reach \(#function) failed as it was called without being implemented.")
    }

    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        assertionFailure("An attempt to reach \(#function) failed as it was called without being implemented.")
    }

    func sirenLatestVersionInstalled() {
        assertionFailure("An attempt to reach \(#function) failed as it was called without being implemented.")
    }

}
