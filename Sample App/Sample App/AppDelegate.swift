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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        window?.makeKeyAndVisible()

        setupSiren()

        return true
    }
    
    func setupSiren() {
        
        let siren = Siren.sharedInstance

        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = true
        
        // Optional - Defaults to .Option
//        siren.alertType = .Option // or .Force, .Skip, .None

        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        siren.majorUpdateAlertType = .option
        siren.minorUpdateAlertType = .option
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option
        
        // Optional - Sets all messages to appear in Spanish. Siren supports many other languages, not just English and Russian.
//        siren.forceLanguageLocalization = .Russian

        // Required
        siren.checkVersion(checkType: .immediately)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Siren.sharedInstance.checkVersion(checkType: .immediately)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Siren.sharedInstance.checkVersion(checkType: .daily)
    }
}

extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog(alertType: SirenAlertType) {
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

    func sirenDidFailVersionCheck(error: NSError) {
        print(#function, error)
    }
    
    /**
        This delegate method is only hit when alertType is initialized to .None
    */
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print(#function, "\(message)")
    }
}
