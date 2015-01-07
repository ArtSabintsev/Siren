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
        // Override point for customization after application launch.
        
        window?.makeKeyAndVisible()
        
        let siren = Siren.sharedInstance
        siren.appID = "376771144" // iTunes Connect App (https://itunes.apple.com/us/app/itunes-connect/id376771144?mt=8)
        siren.presentingViewController = window?.rootViewController
//        siren.debugEnabled = true;
        siren.alertType = .Option
        siren.delegate = self
        siren.checkVersion(.Immediately, shouldShowAlert: false)

        
        return true
    }
}

extension AppDelegate: SirenDelegate
{
    func sirenDidPerformCheckWithoutAlert(message: String) {
        println("\(message)")
    }
}