//
//  AppDelegate.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()

        setupSiren()

        return true
    }
    
    func setupSiren() {
        let siren = Siren.shared

        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = true

        // Optional - Change the name of your app. Useful if you have a long app name and want to display a shortened version in the update dialog (e.g., the UIAlertController).
//        siren.appName = "Test App Name"

        // Optional - Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
//        siren.alertMessaging = SirenAlertMessaging(updateTitle: NSAttributedString(string: "New Fancy Title"),
//                                                   updateMessage: NSAttributedString(string: "New message goes here!"),
//                                                   updateButtonMessage: NSAttributedString(string: "Update Now, Plz!?"),
//                                                   nextTimeButtonMessage: NSAttributedString(string: "OK, next time it is!"),
//                                                   skipVersionButtonMessage: NSAttributedString(string: "Please don't push skip, please don't!"))

        // Optional - Defaults to .Option
//        siren.alertType = .option // or .force, .skip, .none

        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        siren.majorUpdateAlertType = .option
        siren.minorUpdateAlertType = .option
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option

        // Optional - Sets all messages to appear in Russian. Siren supports many other languages, not just English and Russian.
//        siren.forceLanguageLocalization = .russian

        // Optional - Set this variable if your app is not available in the U.S. App Store. List of codes: https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html
//        siren.countryCode = ""

        // Optional - Set this variable if you would only like to show an alert if your app has been available on the store for a few days.
        // This default value is set to 1 to avoid this issue: https://github.com/ArtSabintsev/Siren#words-of-caution
        // To show the update immediately after Apple has updated their JSON, set this value to 0. Not recommended due to aforementioned reason in https://github.com/ArtSabintsev/Siren#words-of-caution.
//        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 3

        // Optional (Only do this if you don't call checkVersion in didBecomeActive)
//        siren.checkVersion(checkType: .immediately)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Siren.shared.checkVersion(checkType: .immediately)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Siren.shared.checkVersion(checkType: .daily)
    }
}

extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        print(#function, alertType)
    }
    
    func sirenUserDidCancel() {
        print(#function)
    }
    
    func sirenUserDidSkipVersion() {
        print(#function)
    }
    
    func sirenUserDidLaunchAppStore() {
        print(#function)
    }

    func sirenDidFailVersionCheck(error: Error) {
        print(#function, error)
    }

    func sirenLatestVersionInstalled() {
        print(#function, "Latest version of app is installed")
    }

    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel) {
        print(#function, "\(lookupModel)")
    }

    // This delegate method is only hit when alertType is initialized to .none
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: UpdateType) {
        print(#function, "\n\(title)\n\(message).\nRelease type: \(updateType.rawValue.capitalized)")
    }
}
