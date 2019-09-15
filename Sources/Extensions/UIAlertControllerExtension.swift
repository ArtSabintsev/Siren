//
//  UIAlertControllerExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

// `UIAlertController` Extension for Siren.
extension UIAlertController {
    /// Presents Siren's `UIAlertController` in a new `UIWindow`.
    ///
    /// - Parameter window: The `UIWindow` that _should_ reference Siren's `UIAlertController`.
    func show(window: UIWindow) {
        guard !self.isBeingPresented else { return }
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: true, completion: nil)
    }

    /// Hides Siren's `UIAlertController` within a given window.
    ///
    /// - Parameter window: The `UIWindow` that references Siren's `UIAlertController`.
    func hide(window: UIWindow) {
        window.isHidden = true
    }
}
