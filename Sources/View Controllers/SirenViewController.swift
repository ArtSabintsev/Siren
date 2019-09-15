//
//  SirenViewController.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// `UIViewController` Extension for Siren
final class SirenViewController: UIViewController {

    /// This creates a retain cycle.
    /// This is needed to retain the UIAlertController in iOS 13.0+
    var retainedWindow: UIWindow?

    /// `UIStatusBarStyle` override.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return retainedWindow?.windowScene?.statusBarManager?.statusBarStyle ?? .default
        } else {
            return UIApplication.shared.statusBarStyle
        }
    }

    deinit {
        retainedWindow = nil
    }
}
