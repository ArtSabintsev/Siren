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
    /// `UIStatusBarStyle` override.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
}
