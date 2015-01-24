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
        
        // Required
        siren.presentingViewController = window?.rootViewController
        
        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = true;
        
        // Optional
        siren.alertType = .Option
        
        // Optional
//        siren.forceLanguageLocalization = .Spanish // Optional: Sets all messages to appear in spanish. Siren supports many other languages, not just English and Spanish.
        
        // Required
        siren.checkVersion(.Immediately)
    }
}

extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog() {
        println("sirenDidShowUpdateDialog")
    }
    
    func sirenUserDidCancel() {
        println("sirenUserDidCancel")
    }
    
    func sirenUserDidSkipVersion() {
        println("sirenUserDidSkipVersion")
    }
    
    func sirenUserDidLaunchAppStore() {
        println("sirenUserDidLaunchAppStore")
    }
    
    /**
        This method is only hit when alertType is initialized to .None
    */
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        println("\(message)")
    }
}