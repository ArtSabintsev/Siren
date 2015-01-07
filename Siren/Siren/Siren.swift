//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import Foundation
import UIKit

// MARK: SirenDelegate Protocol
@objc protocol SirenDelegate {
    optional func sirenDidShowUpdateDialog()        // User presented with update dialog
    optional func sirenUserDidLaunchAppStore()      // User did click on button that launched App Store.app
    optional func sirenUserDidSkipVersion()         // User did click on button that skips version update
    optional func sirenUserDidCancel()              // User did click on button that cancels update dialog
    
    // Siren performed version check and did not display alert
    optional func sirenDidPerformCheckWithoutAlert(message: String)
}

// MARK: Enumerations
/**
    Type of alert to present
*/
public enum SirenAlertType
{
    case Force        // Forces user to update your app
    case Option       // (DEFAULT) Presents user with option to update app now or at next launch
    case Skip         // Presents User with option to update the app now, at next launch, or to skip this version all together
    case None         // Don't show the alert type (useful for skipping Patch, Minor, or Major updates)
}

/**
    How often alert should be presented
*/
public enum SirenVersionCheckType : Int
{
    case Immediately = 0
    case Daily = 1
    case Weekly = 7
}

/**
    Internationalization
*/
public enum SirenLanguageType: String
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

// MARK: Siren
public class Siren: NSObject
{
    // MARK: Constants
    let sirenDefaultSkippedVersion = "Siren User Decided To Skip Version Update"
    let sirenDefaultStoredVersionCheckDate = "Siren Stored Date From Last Version Check"
    let currentVersion = NSBundle.mainBundle().currentVersion()
    let bundlePath = NSBundle.mainBundle().pathForResource("Siren", ofType: "Bundle")
    
    // MARK: Variables
    // Delegate
    weak var delegate: SirenDelegate?
    
    // Debug Flag
    var debugEnabled = false
    
    // Alert Vars
    var alertType = SirenAlertType.Option
    var majorUpdateAlertType: SirenAlertType?
    var minorUpdateAlertType: SirenAlertType?
    var patchUpdateAlertType: SirenAlertType?
    
    // Required Vars
    var shouldShowAlert = true
    var appID: String?
    var presentingViewController: UIViewController?
    
    // Optional Vars
    var appName: String = (NSBundle.mainBundle().infoDictionary?[kCFBundleNameKey] as? String) ?? ""
    var countryCode: String?
    var forceLanguageLocalization: SirenLanguageType?
    var alertControllerTintColor: UIColor?
    
    // Private
    private var lastVersionCheckPerformedOnDate: NSDate?
    private var currentAppStoreVersion: String?
    
    // MARK: Initialization
    public class var sharedInstance: Siren {
        struct Singleton {
            static let instance = Siren()
        }
        
        return Singleton.instance
    }
    
    override init() {
        lastVersionCheckPerformedOnDate = NSUserDefaults.standardUserDefaults().objectForKey(sirenDefaultStoredVersionCheckDate) as? NSDate;
    }
    
    // MARK: Check Version
    func checkVersion(checkType: SirenVersionCheckType, shouldShowAlert: Bool) {
        
        self.shouldShowAlert = shouldShowAlert
        
        if (appID == nil) {
            println("[Siren]: Please make sure that you have set 'appID' before calling checkVersion.")
        } else if (useAlertController && presentingViewController == nil) { // iOS 8 only
            println("[Siren]: Please make sure that you have set 'presentingViewController' before calling checkVersion.")
        } else {
            
            if checkType == .Immediately {
                performVersionCheck()
            } else {
                if let lastCheckDate = lastVersionCheckPerformedOnDate {
                    if daysSinceLastVersionCheckDate() >= checkType.rawValue {
                        performVersionCheck()
                    }
                } else {
                    performVersionCheck()
                }
            }
            
        }
    }
    
    func performVersionCheck() {
        
        // Create Request
        let itunesURL = iTunesURLFromString()
        let request = NSMutableURLRequest(URL: itunesURL)
        request.HTTPMethod = "GET"
        
        // Perform Request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if data.length > 0 {
                
                // Convert JSON data to Swift Dictionary of type [String : AnyObject]
                let appData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Store version comparison date
                    self.lastVersionCheckPerformedOnDate = NSUserDefaults.standardUserDefaults().objectForKey(self.sirenDefaultStoredVersionCheckDate) as? NSDate
                    NSUserDefaults.standardUserDefaults().setObject(self.lastVersionCheckPerformedOnDate, forKey: self.sirenDefaultStoredVersionCheckDate)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // Extract current version on the AppStore
                    if self.debugEnabled {
                        println("[Siren] JSON results: \(appData)");
                    }
                    
                    // Process Results
                    self.processVersionCheckResults(appData!)
                    
                })
                
            } else {
                if self.debugEnabled {
                    println("[Siren] Error retrieving App Store data: \(error.localizedDescription)")
                }
            }
        })
        
        task.resume()
    }
    
    func processVersionCheckResults(results: [String : AnyObject]) {
        
        self.currentAppStoreVersion = results["results"]?[0]["version"] as? String
        if let currentAppStoreVersion = self.currentAppStoreVersion {
            if self.isAppStoreVersionNewer() {
                if (self.shouldShowAlert) {
                    self.showAlertIfCurrentAppStoreVersionNotSkipped()
                } else {
                    self.delegate?.sirenDidPerformCheckWithoutAlert?(self.localizedNewVersionMessage())
                }
            }
        } else {
            if self.debugEnabled {
                println("[Siren] Error retrieving App Store verson number")
            }
        }
    }
}

// MARK: Alert
private extension Siren {
    func showAlertIfCurrentAppStoreVersionNotSkipped() {
        
        self.alertType = self.setAlertType()
        
        if let previouslySkippedVersion = NSUserDefaults.standardUserDefaults().objectForKey(sirenDefaultSkippedVersion) as? String {
            if currentAppStoreVersion! != previouslySkippedVersion {
                showAlert()
            }
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        
        let updateAvailableMessage = NSBundle().localizedString("Update Available", forceLanguageLocalization: forceLanguageLocalization)
        var newVersionMessage = localizedNewVersionMessage();
        
        if (useAlertController) { // iOS 8
            
            let alertController = UIAlertController(title: updateAvailableMessage, message: newVersionMessage, preferredStyle: .Alert)
            
            if let alertControllerTintColor = alertControllerTintColor {
                alertController.view.tintColor = alertControllerTintColor
            }
            
            switch alertType {
            case .Force:
                alertController.addAction(updateAlertAction());
            case .Option:
                alertController.addAction(nextTimeAlertAction());
                alertController.addAction(updateAlertAction());
            case .Skip:
                alertController.addAction(nextTimeAlertAction());
                alertController.addAction(updateAlertAction());
                alertController.addAction(skipAlertAction());
            case .None:
                return
            }
            
            presentingViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        } else { // iOS 7
            
            var alertView: UIAlertView?
            let updateButtonTitle = localizedUpdateButtonTitle()
            let nextTimeButtonTitle = localizedNextTimeButtonTitle()
            let skipButtonTitle = localizedSkipButtonTitle()
            switch alertType {
            case .Force:
                alertView = UIAlertView(title: updateAvailableMessage, message: newVersionMessage, delegate: self, cancelButtonTitle: updateButtonTitle)
            case .Option:
                alertView = UIAlertView(title: updateAvailableMessage, message: newVersionMessage, delegate: self, cancelButtonTitle: nextTimeButtonTitle)
                alertView!.addButtonWithTitle(updateButtonTitle)
            case .Skip:
                alertView = UIAlertView(title: updateAvailableMessage, message: newVersionMessage, delegate: self, cancelButtonTitle: skipButtonTitle)
                alertView!.addButtonWithTitle(updateButtonTitle)
                alertView!.addButtonWithTitle(nextTimeButtonTitle)
            case .None:
                return
            }
            
            if let alertView = alertView {
                alertView.show()
            }
        }
    }
    
    func updateAlertAction() -> UIAlertAction {
        let title = localizedUpdateButtonTitle()
        let action = UIAlertAction(title: title, style: .Default) { (alert: UIAlertAction!) -> Void in
            self.launchAppStore()
            self.delegate?.sirenUserDidLaunchAppStore?()
            return
        }
        
        return action
    }
    
    func nextTimeAlertAction() -> UIAlertAction {
        let title = localizedNextTimeButtonTitle()
        let action = UIAlertAction(title: title, style: .Default) { (alert: UIAlertAction!) -> Void in
            self.delegate?.sirenUserDidCancel?()
            return
        }
        
        return action
    }
    
    func skipAlertAction() -> UIAlertAction {
        let title = localizedSkipButtonTitle()
        let action = UIAlertAction(title: title, style: .Default) { (alert: UIAlertAction!) -> Void in
            self.delegate?.sirenUserDidSkipVersion?()
            return
        }
        
        return action
    }

}

// MARK: Helpers
private extension Siren {
    
    func iTunesURLFromString() -> NSURL {
        
        var storeURLString = "https://itunes.apple.com/lookup?id=\(appID!)"
        
        if let countryCode = countryCode {
            storeURLString += "&country=\(countryCode)"
        }
        
        if debugEnabled {
            println("[Siren] iTunes Lookup URL: \(storeURLString)");
        }
        
        return NSURL(string: storeURLString)!
    }
    
    func daysSinceLastVersionCheckDate() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitDay, fromDate: lastVersionCheckPerformedOnDate!, toDate: NSDate(), options: nil)
        return components.day
    }
    
    func isAppStoreVersionNewer() -> Bool {
        
        var newVersionExists = false
        
        if let currentVersion = self.currentVersion {
            if (currentVersion.compare(currentAppStoreVersion!, options: .NumericSearch) == NSComparisonResult.OrderedAscending) {
                newVersionExists = true
            }
        }
        
        return newVersionExists
    }
    
    /*
        TODO: Potentially turn this into a custom setter/getter with property observers
        https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html#//apple_ref/doc/uid/TP40014097-CH14-ID262
    */
    func setAlertType() -> SirenAlertType {
        
        if majorUpdateAlertType == nil {
            majorUpdateAlertType = alertType
        }
        
        if minorUpdateAlertType == nil {
            minorUpdateAlertType = alertType
        }
        
        if patchUpdateAlertType == nil {
            patchUpdateAlertType = alertType
        }
        
        let oldVersion = split(currentVersion!, {$0 == "."}, maxSplit: Int.max, allowEmptySlices: false).map {$0.toInt() ?? 0}
        let newVersion = split(currentAppStoreVersion!, {$0 == "."}, maxSplit: Int.max, allowEmptySlices: false).map {$0.toInt() ?? 0}
        
        if oldVersion.count == 3 && newVersion.count == 3 {
            if newVersion[0] > oldVersion[0] { // A.b.c
                alertType = majorUpdateAlertType!
            } else if newVersion[1] > oldVersion[1] { // a.B.c
                alertType = minorUpdateAlertType!
            } else if newVersion[2] > oldVersion[2] { // a.b.C
                alertType = patchUpdateAlertType!
            }
        }
        
        return alertType
    }
    
    // iOS 8 Compatibility Check
    var useAlertController: Bool { // iOS 8 check
        return objc_getClass("UIAlertController") != nil
    }
    
    // Actions
    func launchAppStore() {
        let iTunesString =  "https://itunes.apple.com/app/id\(appID)";
        let iTunesURL = NSURL(string: iTunesString);
        UIApplication.sharedApplication().openURL(iTunesURL!);
    }
}

// MARK: String Localization
private extension Siren {

    func localizedNewVersionMessage() -> String {
        
        let newVersionMessageToLocalize = "A new version of %@ is available. Please update to version %@ now."
        var newVersionMessage = NSBundle().localizedString(newVersionMessageToLocalize, forceLanguageLocalization: forceLanguageLocalization)
        newVersionMessage = String(format: newVersionMessage!, appName, currentAppStoreVersion!)
        
        return newVersionMessage!
    }
    
    func localizedUpdateButtonTitle() -> String {
        return NSBundle().localizedString("Update", forceLanguageLocalization: forceLanguageLocalization)!
    }
    
    func localizedNextTimeButtonTitle() -> String {
        return NSBundle().localizedString("Next time", forceLanguageLocalization: forceLanguageLocalization)!
    }
    
    func localizedSkipButtonTitle() -> String {
        return NSBundle().localizedString("Skip this version", forceLanguageLocalization: forceLanguageLocalization)!;
    }
}

// MARK: NSBundle Extension
private extension NSBundle {
    
    func currentVersion() -> String? {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
    }

    func sirenBundlePath() -> String {
        return NSBundle.mainBundle().pathForResource("Siren", ofType: "bundle") as String!
    }

    func sirenForcedBundlePath(forceLanguageLocalization: SirenLanguageType) -> String {
        let path = sirenBundlePath()
        let name = forceLanguageLocalization.rawValue
        return NSBundle(path: path)!.pathForResource(name, ofType: "lproj")!
    }

    func localizedString(stringKey: String, forceLanguageLocalization: SirenLanguageType?) -> String? {
        var path: String
        let table = "SirenLocalizable"
        if let forceLanguageLocalization = forceLanguageLocalization {
            path = sirenForcedBundlePath(forceLanguageLocalization)
        } else {
            path = sirenBundlePath()
        }
        
        return NSBundle(path: path)?.localizedStringForKey(stringKey, value: stringKey, table: table)
    }
}

// MARK: UIAlertViewDelegate
extension Siren: UIAlertViewDelegate
{
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        switch alertType {
            
        case .Force:
            launchAppStore()
        case .Option:
            if buttonIndex == 1 { // Launch App Store.app
                launchAppStore()
                self.delegate?.sirenUserDidLaunchAppStore?()
            } else { // Ask user on next launch
                self.delegate?.sirenUserDidCancel?()
            }
        case .Skip:
            if buttonIndex == 0 { // Launch App Store.app
                NSUserDefaults.standardUserDefaults().setObject(currentAppStoreVersion!, forKey: sirenDefaultSkippedVersion)
                NSUserDefaults.standardUserDefaults().synchronize()
                self.delegate?.sirenUserDidSkipVersion?()
            } else if buttonIndex == 1 {
                launchAppStore()
                self.delegate?.sirenUserDidLaunchAppStore?()
            } else if buttonIndex == 2 { // Ask user on next launch
                self.delegate?.sirenUserDidCancel?()
            }
        case .None:
            println("None")
        }
    }
}
