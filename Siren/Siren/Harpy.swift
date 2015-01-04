//
//  Harpy.swift
//  HarpyProject
//
//  Created by Aaron on 1/3/15.
//  Copyright (c) 2015 Aaron Brager. All rights reserved.
//

import UIKit

@objc protocol HarpyDelegate {
    optional func harpyDidShowUpdateDialog()       // User presented with update dialog
    optional func harpyUserDidLaunchAppStore()     // User did click on button that launched App Store.app
    optional func harpyUserDidSkipVersion()        // User did click on button that skips version update
    optional func harpyUserDidCancel()             // User did click on button that cancels update dialog
}

class Harpy {
    enum HarpyLanguage : String {
        case Basque = "eu"
        case ChineseSimplified = "zh-Hans"
        case ChineseTraditional = "zh-Hant"
        case Danish = "da"
        case Dutch = "nl"
        case English = "en"
        case French = "fr"
        case German = "de"
        case Italian = "it"
        case Japanese = "ja"
        case Korean = "ko"
        case Portuguese = "pt"
        case Russian = "ru"
        case Slovenian = "sl"
        case Swedish = "sv"
        case Spanish = "es"
    }
    
    enum HarpyAlertType {
        case Force        // Forces user to update your app
        case Option       // (DEFAULT) Presents user with option to update app now or at next launch
        case Skip         // Presents User with option to update the app now, at next launch, or to skip this version all together
        case None         // Don't show the alert type , usefull for skipping Patch ,Minor, Major update
    }
    
    enum HarpyCheckFilter {
        case RightNow
        case OrIgnoreIfCheckedInPriorDay
        case OrIgnoreIfCheckedInPriorWeek
    }
    
    weak var delegate : HarpyDelegate?
    var presentingViewController : UIViewController?

    var appID : String?
    var appName : String = (NSBundle.mainBundle().infoDictionary?[kCFBundleNameKey] as? String) ?? ""
    
    var countryCode : String?
    var forceLanguageLocalization : HarpyLanguage?
    
    var debugEnabled = false

    var alertType = HarpyAlertType.Option

    var majorUpdateAlertType = HarpyAlertType.Option
    var minorUpdateAlertType = HarpyAlertType.Option
    var patchUpdateAlertType = HarpyAlertType.Option

    var alertControllerTintColor : UIColor?

    let HARPY_DEFAULT_SHOULD_SKIP_VERSION = "Harpy Should Skip Version Boolean"
    let HARPY_DEFAULT_SKIPPED_VERSION = "Harpy User Decided To Skip Version Update Boolean"
    let HARPY_DEFAULT_STORED_VERSION_CHECK_DATE = "Harpy Stored Date From Last Version Check"
    
    let currentVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String?
    let bundlePath = NSBundle.mainBundle().pathForResource("Harpy", ofType: "Bundle")
    
    class var sharedInstance : Harpy {
        struct HarpyStruct {
            static let instance = Harpy()
        }
        
        return HarpyStruct.instance
    }
    
    class func iTunesURLString(id : String, country : String?) -> String {
        var url = "http://itunes.apple.com/lookup?id=\(id)"
        
        if let country = country {
            url += "&country=\(country)"
        }
        
        return url
    }
    
    func harpyBundle -> NSBundle? {
        var bundle : NSBundle
        var path : String?
        
        if let language = forceLanguageLocalization {
            path = NSBundle(path: bundlePath!)?.pathForResource(language, ofType: "lproj")
        } else {
            
        }
    }
    
    func harpyLocalizedString(key : String) -> String {
        
    }
    
    func checkVersion(filter : HarpyCheckFilter) {
        
    }
    
}