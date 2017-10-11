//
//  SirenDelegate.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 4/8/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// MARK - Siren UpdateType

/// `UpdateType` defines what kind of update is available
/// It is used as parameter if user wants to use
/// custom alert to inform the user about an update.
///
/// - major: Major release available: A.b.c.d
/// - minor: Minor release available: a.B.c.d
/// - patch: Patch release available: a.b.C.d
/// - revision: Revision release available: a.b.c.D
/// - unknown: No information available about the update
public enum UpdateType: String {
    case major
    case minor
    case patch
    case revision
    case unknown
}

// MARK: - SirenDelegate Protocol

/// Delegate that handles all codepaths for Siren upon version check completion.
public protocol SirenDelegate: NSObjectProtocol {
    /// User presented with update dialog.
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType)

    /// User did click on button that launched App Store.app.
    func sirenUserDidLaunchAppStore()

    /// User did click on button that skips version update.
    func sirenUserDidSkipVersion()

    /// User did click on button that cancels update dialog.
    func sirenUserDidCancel()

    /// Siren failed to perform version check (may return system-level error).
    func sirenDidFailVersionCheck(error: Error)

    /// Siren performed version check and did not display alert.
    func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType)

    /// Siren performed version check and latest version is installed.
    func sirenLatestVersionInstalled()
}

// MARK: - SirenDelegate Protocol Extension

public extension SirenDelegate {

    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        printMessage()
    }

    func sirenUserDidLaunchAppStore() {
        printMessage()
    }

    func sirenUserDidSkipVersion() {
        printMessage()
    }

    func sirenUserDidCancel() {
        printMessage()
    }

    func sirenDidFailVersionCheck(error: Error) {
        printMessage()
    }

    func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType) {
        printMessage()
    }

    func sirenLatestVersionInstalled() {
        printMessage()
    }

    private func printMessage(_ function: String = #function) {
        SirenLog("The default implementation of \(function) is being called. You can ignore this message if you do not care to implement this method in your `SirenDelegate` conforming structure.")
    }

}
