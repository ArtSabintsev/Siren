//
//  UpdateResults.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/1/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// The relevant metadata returned from Siren upon completing a successful version check.
public struct UpdateResults {
    /// The `UIAlertAction` the user chose upon being presented with the update alert.
    /// Defaults to `unknown` until an alert is actually presented.
    public var alertAction: AlertAction = .unknown

    /// The Siren-supported locale that was used for the string in the update alert.
    public let localization: Localization

    /// The Swift-mapped and unwrapped API model, if a successful version check was performed.
    public let model: Model

    /// The type of update that was returned for the API.
    public var updateType: RulesManager.UpdateType = .unknown
}
