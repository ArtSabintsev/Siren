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
    // Class Constants (Public)
    let SirenDefaultShouldSkipVersion = "Siren Should Skip Version"
    let SirenDefaultSkippedVersion = "Siren User Decided To Skip Version Update"
    let SirenDefaultStoredVersionCheckDate = "Siren Stored Date From Last Version Check"
    let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String?
    let bundlePath = NSBundle.mainBundle().pathForResource("Siren", ofType: "Bundle")
    
    // Class Variables (Public)
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
    
    // Class Variables (Private)
    private var appData: NSDictionary?
    private var lastVersionCheckPerformedOnDate: NSDate?
    private var currentAppStoreVersion: String?
    
    // MARK: Initialization
    public class var sharedInstance: Siren {
        struct Singleton {
            static let instance = Siren()
        }
        
        return Singleton.instance
    }

    // MARK: Check Version
    func checkVersion() {

        if (appID == nil || presentingViewController == nil) {
            println("[Siren]: Please make sure that you have set 'appID' and 'presentingViewController' before calling checkVersion, checkVersionDaily, or checkVersionWeekly")
        } else {
            performVersionCheck()
        }
    }
    
    // MARK: Helpers
    func iTunesURLFromString() -> NSURL {
        
        var route = "http://itunes.apple.com/lookup?id=\(appID!)"
        
        if let countryCode = self.countryCode {
            route += "&country=\(countryCode)"
        }
        
        return NSURL(string: route)!
    }
    
    func performVersionCheck() {
        
        let itunesURL = iTunesURLFromString()
        let request = NSMutableURLRequest(URL: itunesURL)
        request.HTTPMethod = "POST"
        let session = NSURLSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if (data.length > 0) {
                self.appData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary
                
                if (self.debugEnabled) {
                    println("[Siren] JSON Results: \(self.appData)");
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Store version comparison date
                    self.lastVersionCheckPerformedOnDate = NSDate()
                    NSUserDefaults.standardUserDefaults().setObject(self.lastVersionCheckPerformedOnDate, forKey: self.SirenDefaultStoredVersionCheckDate)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // Extract all versions that have been uploaded to the AppStore
                    let versionsInAppStore: NSArray? = self.appData?.objectForKey("results")?.objectForKey("version") as? NSArray
                    if ((versionsInAppStore?.count) != nil) {
                        self.currentAppStoreVersion = versionsInAppStore?.objectAtIndex(0) as? String
                    }
                    
                })
                
            }
        })
    }
    
    func checkIfAppStoreVersionIsNewestVersion() {
        
    }
    
    
    // MARK: Bundle
    
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

private extension NSBundle {
    
    func sirenBundlePath() -> String {
        return NSBundle().pathForResource("Siren", ofType: ".bundle") as String!
    }

    func forcedBundlePath() -> String? {
        let path = sirenBundlePath()
        let name = Siren.sharedInstance.forceLanguageLocalization?.rawValue
        return NSBundle(path: path)?.pathForResource(name, ofType: "lproj")
    }
    
    func currentVersion() -> String? {
        return NSBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
    }
    
    func localizedString(stringKey: NSString) -> NSString? {
        let path = sirenBundlePath()
        let table = "SirenLocalizable"
        return NSBundle(path: path)?.localizedStringForKey(stringKey, value: stringKey, table: table)
    }
    
    func forcedLocalizedString(stringKey: NSString) -> NSString? {
        let path = forcedBundlePath()
        let table = "SirenLocalizable"
        return NSBundle(path: path!)?.localizedStringForKey(stringKey, value: stringKey, table: table)
    }
    
}
