//
//  AppDelegate.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import Siren
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var siren: Siren?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()
        setupSiren()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        siren?.wail { (results, error) in
            if let results = results {
                print(results)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func setupSiren() {
        siren = Siren(debugEnabled: true)
    }
}
