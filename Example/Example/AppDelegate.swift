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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()

        Siren.shared.wail { (results, error) in
            print(error?.localizedDescription)
        }

//        let siren = Siren.shared
//        siren.presentationManager = PresentationManager(forceLanguageLocalization: .russian)
//        siren.rulesManager = RulesManager(globalRules: .annoying)
//
//        Siren.shared.wail { (results, error) in
//            if let results = results {
//                print("AlertAction ", results.alertAction)
//                print("Localization ", results.localization)
//                print("LookupModel ", results.lookupModel)
//                print("UpdateType ", results.updateType)
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }

        return true
    }
}
