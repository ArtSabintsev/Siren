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

    func setupSiren() {
        // Optional - Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
//        let alertConfiguration = AlertConfiguration(alertTintColor: .purple,
//                                                    updateTitle: NSAttributedString(string: "New Fancy Title"),
//                                                    updateMessage: NSAttributedString(string: "New custom update message goes here!"),
//                                                    updateButtonMessage: NSAttributedString(string: "Update Now, Please!"),
//                                                    nextTimeButtonMessage: NSAttributedString(string: "OK, next time it is!"),
//                                                    skipVersionButtonMessage: NSAttributedString(string: "Please don't push skip, please don't!"))

        let settings = Settings()
        let rules = Rules(checkFrequency: .immediately,
                          forAlertType: .force)
        let rulesManager = RulesManager(globalRules: rules,
                                        showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
        let alertConfiguration = AlertConfiguration()

        siren = Siren(settings: settings,
                      rulesManager: rulesManager,
                      alertConfiguration: alertConfiguration,
                      debugEnabled: true)


        // Optional - Sets all messages to appear in Russian. Siren supports many other languages, not just English and Russian.
//        siren.forceLanguageLocalization = .russian

        // Optional - Set this variable if your app is not available in the U.S. App Store. List of codes:
        // https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html
//        siren.countryCode = ""

        // Optional - Set this variable if you would only like to show an alert if your app has been available on the store for a few days.
        // This default value is set to 1 to avoid this issue: https://github.com/ArtSabintsev/Siren#words-of-caution
        // To show the update immediately after Apple has updated their JSON, set this value to 0. Not recommended due to aforementioned reason in https://github.com/ArtSabintsev/Siren#words-of-caution.
//        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        siren?.wail()
    }
}
