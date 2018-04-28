//
//  SirenDelegate.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 4/8/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// MARK - Siren UpdateType

/// `UpdateType` defines what kind of update is available.
/// It is used as parameter if user wants to use
/// custom alert to inform the user about an update.
///
/// - major: Major release available: A.b.c.d
/// - minor: Minor release available: a.B.c.d
/// - patch: Patch release available: a.b.C.d
/// - revision: Revision release available: a.b.c.D
/// - unknown: No information available about the update.
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
    /// Siren performed version check and did not display alert.
    func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType)

    /// Siren failed to perform version check.
    ///
    /// - Note:
    ///     Depending on the reason for failure,
    ///     a system-level error may be returned.
    func sirenDidFailVersionCheck(error: Error)

    /// User presented with update dialog.
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType)

    /// Siren performed a version check and latest version is installed.
    func sirenLatestVersionInstalled()

    /// Provides the decoded JSON information from a successful version check call.
    ///
    /// - Parameter lookupModel: The `Decodable` model representing the JSON results from the iTunes Lookup API.
    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel)

    /// User did click on button that cancels update dialog.
    func sirenUserDidCancel()

    /// User did click on button that launched "App Store.app".
    func sirenUserDidLaunchAppStore()

    /// User did click on button that skips version update.
    func sirenUserDidSkipVersion()
}

// MARK: - SirenDelegate Protocol Extension

public extension SirenDelegate {

    func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType) {
        printMessage()
    }

    func sirenDidFailVersionCheck(error: Error) {
        printMessage()
    }

    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        printMessage()
    }

    func sirenLatestVersionInstalled() {
        printMessage()
    }

    func sirenUserDidCancel() {
        printMessage()
    }

    func sirenUserDidLaunchAppStore() {
        printMessage()
    }

    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel) {
        printMessage()
    }

    func sirenUserDidSkipVersion() {
        printMessage()
    }

    private func printMessage(_ function: String = #function) {
        SirenLog("The default implementation of \(function) is being called. You can ignore this message if you do not care to implement this method in your `SirenDelegate` conforming structure.")
    }

}
