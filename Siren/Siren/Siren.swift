//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import Foundation
import UIKit

// MARK: Delegate
@objc protocol SirenDelegate {
    optional func sirenDidShowUpdateDialog()       // User presented with update dialog
    optional func sirenUserDidLaunchAppStore()     // User did click on button that launched App Store.app
    optional func sirenUserDidSkipVersion()        // User did click on button that skips version update
    optional func sirenUserDidCancel()             // User did click on button that cancels update dialog
}

// MARK: Enumerations
/**
    Localization
*/
public enum SirenLanguage: String
{
    case Basque = "eu"
    case ChineseSimplified = "zh-Hans"
    case ChineseTraditional = "zh-Hant"
    case Danish = "da"
    case Dutch = "nl"
    case English = "en"
    case French = "fr"
    case Hebrew = "he"
    case German = "de"
    case Italian = "it"
    case Japanese = "ja"
    case Korean = "ko"
    case Portuguese = "pt"
    case Russian = "ru"
    case Slovenian = "sl"
    case Sweidsh = "sv"
    case Spanish = "es"
    case Turkish = "tr"
}

/**
    Type of alert to present
*/
public enum SirenAlertType
{
    case Force        // Forces user to update your app
    case Option       // (DEFAULT) Presents user with option to update app now or at next launch
    case Skip         // Presents User with option to update the app now, at next launch, or to skip this version all together
    case None         // Don't show the alert type , usefull for skipping Patch ,Minor, Major update
}

// MARK: Main Class
public class Siren : NSObject
{
    // MARK: Constants
    // Class Constants
    let SirenShouldSkipVersionDefault = "Siren Should Skip Version"
    let SirenSkippedVersionDefault = "Siren User Decided To Skip Version Update"
    let SirenStoredVersionCheckDate = "Harpy Stored Date From Last Version Check"
    let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String?
    let bundlePath = NSBundle.mainBundle().pathForResource("Harpy", ofType: "Bundle")
    
    // Class Variables
    var debugEnabled = false
    
    weak var delegate: SirenDelegate?
    
    var appID: String?
    var appName: String = (NSBundle.mainBundle().infoDictionary?[kCFBundleNameKey] as? String) ?? ""
    var countryCode: String?
    var forceLanguageLocalization: SirenLanguage?
    
    var alertType = SirenAlertType.Option
    var majorUpdateAlertType = SirenAlertType.Option
    var minorUpdateAlertType = SirenAlertType.Option
    var patchUpdateAlertType = SirenAlertType.Option
    
    var presentingViewController: UIViewController?
    var alertControllerTintColor: UIColor?
    
    
    // MARK: Initialization
    public class var sharedInstance: Siren {
        struct Singleton {
            static let instance = Siren()
        }
        
        return Singleton.instance
    }

    // MARK: Check Version
    func checkVersion() {
        
        if (appID != nil || presentingViewController != nil) {
            println("[Harpy]: Please make sure that you have set 'appID' and 'presentatingViewController' before calling checkVersion, checkVersionDaily, or checkVersionWeekly")
        } else {
            var itunesURL = iTunesURLFromString()
        }
    }
    
    // MARK: Helpers
    func iTunesURLFromString() -> NSURL {
        
        var route = "http://itunes.apple.com/lookup?id=\(appID)"
        
        if let countryCode = self.countryCode {
            route += "&country=\(countryCode)"
        }
        
        return NSURL(string: route)!
    }
    
//    func sirenBundle -> NSBundle? {
//        var bundle : NSBundle
//        var path : String?
//        
//        if let language = forceLanguageLocalization {
//            path = NSBundle(path: bundlePath!)?.pathForResource(language, ofType: "lproj")
//        } else {
//            
//        }
//    }
//    
//    func harpyLocalizedString(key : String) -> String {
//        
//    }
    
}