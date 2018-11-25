//
//  UIAlertControllerExtension.swift
//  Siren
//
//  Created by Arthur Sabintsev on 3/17/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIAlertController Extension for Siren

extension UIAlertController {
    func show(window: UIWindow) {
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: true, completion: nil)
    }

    func hide(window: UIWindow) {
        window.isHidden = true
    }
}
