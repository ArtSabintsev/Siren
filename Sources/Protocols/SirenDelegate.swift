//
//  SirenDelegate.swift
//  Siren
//
//  Created by Arthur Sabintsev on 4/8/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - SirenDelegate Protocol

/// Delegate that handles all codepaths for Siren upon version check completion.
public protocol SirenDelegate: NSObjectProtocol {
    /// Siren performed a version check and did not display an alert.
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: Constants.UpdateType)

    /// Siren failed to perform version check.
    ///
    /// - Note:
    ///     Depending on the reason for failure,
    ///     a system-level error may be returned.
    func sirenDidFailVersionCheck(error: Error)

    /// User presented with an update dialog.
    ///
    /// - Parameter alertType: The type of alert that was presented.
    func sirenDidShowUpdateDialog(alertType: Constants.AlertType)

    /// Siren performed a version check and the latest version was already installed.
    func sirenLatestVersionInstalled()

    /// Provides the decoded JSON information from a successful version check call.
    ///
    /// - Parameter lookupModel: The `Decodable` model representing the JSON results from the iTunes Lookup API.
    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: LookupModel)

    /// User did click on button that cancels update dialog.
    func sirenUserDidCancel()

    /// User did click on button that launched "App Store.app".
    func sirenUserDidLaunchAppStore()

    /// User did click on button that skips version update.
    func sirenUserDidSkipVersion()
}

// MARK: - SirenDelegate Protocol Extension

public extension SirenDelegate {
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: Constants.UpdateType) {
        printMessage()
    }

    func sirenDidFailVersionCheck(error: Error) {
        printMessage()
    }

    func sirenDidShowUpdateDialog(alertType: Constants.AlertType) {
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

    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: LookupModel) {
        printMessage()
    }

    func sirenUserDidSkipVersion() {
        printMessage()
    }

    private func printMessage(_ function: String = #function) {
        Log("The default implementation of \(function) is being called. You can ignore this message if you do not care to implement this method in your `SirenDelegate` conforming structure.")
    }
}
