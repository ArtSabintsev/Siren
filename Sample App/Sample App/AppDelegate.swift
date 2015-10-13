//
//  AppDelegate.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window?.makeKeyAndVisible()
        
        setupSiren()

        return true
    }
    
    func setupSiren() {
        
        let siren = Siren.sharedInstance
        
        // Required
        siren.appID = "376771144" // For this example, we're using the iTunes Connect App (https://itunes.apple.com/us/app/itunes-connect/id376771144?mt=8)
        
        // Use manifest
        siren.checkMethod = SirenVersionCheckMethod.Manifest("https://server-and-path-to/manifest.plist")
        
        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = true;
        
        // Optional - Defaults to .Option
//        siren.alertType = .Option // or .Force, .Skip, .None
        
        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        siren.majorUpdateAlertType = .Option
        siren.minorUpdateAlertType = .Option
        siren.patchUpdateAlertType = .Option
        siren.revisionUpdateAlertType = .Option
        
        // Optional - Sets all messages to appear in Spanish. Siren supports many other languages, not just English and Spanish.
//        siren.forceLanguageLocalization = .Spanish
        
        // Required
        siren.checkVersion(.Immediately)
    }
}

extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog() {
        print("sirenDidShowUpdateDialog")
    }
    
    func sirenUserDidCancel() {
        print("sirenUserDidCancel")
    }
    
    func sirenUserDidSkipVersion() {
        print("sirenUserDidSkipVersion")
    }
    
    func sirenUserDidLaunchAppStore() {
        print("sirenUserDidLaunchAppStore")
    }
    
    /**
        This delegate method is only hit when alertType is initialized to .None
    */
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print("\(message)")
    }
}
