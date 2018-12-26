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

//        defaultExample()
        defaultExampleUsingCompletionHandler()
//        minimalCustomizationPresentationExample()
//        forceLocalizationCustomizationPresentationExample()
//        customMessagingPresentationExample()
        return true
    }
}

// Siren Examples

private extension AppDelegate {

    func defaultExample() {
        Siren.shared.wail()
    }

    func defaultExampleUsingCompletionHandler() {
        Siren.shared.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func minimalCustomizationPresentationExample() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(alertTintColor: .purple,
                                                        appName: "Siren Example App Override!")
        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func forceLocalizationCustomizationPresentationExample() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(forceLanguageLocalization: .russian)
        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func customMessagingPresentationExample() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(alertTitle: "Update Now, OK?",
                                                        nextTimeButtonTitle: "Next time, please!?")
        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
