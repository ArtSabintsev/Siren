//
//  AlertAction.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/1/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// The `UIAlertController` button that was pressed upon being presented an update alert.
public enum AlertAction {
    /// The user clicked on the `Update` option, which took them to the app's App Store page.
    case appStore
    /// The user clicked on the `Next Time` option, which dismissed the alert.
    case nextTime
    /// The user clicked on the `Skip this version` option, which dismissed the alert.
    case skip
    /// (Default) The user never chose an option. This is returned when an error is thrown by Siren.
    case unknown
}
