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
    // Class Constants (Public)
    let sirenDefaultSkippedVersion = "Siren User Decided To Skip Version Update"
    let sirenDefaultStoredVersionCheckDate = "Siren Stored Date From Last Version Check"
    let currentVersion = NSBundle.mainBundle().currentVersion()
    let bundlePath = NSBundle.mainBundle().pathForResource("Siren", ofType: "Bundle")
    
    // Class Variables (Public)
    var debugEnabled = false
    weak var delegate: SirenDelegate?
    var appID: String?
    var appName: String = (NSBundle.mainBundle().infoDictionary?[kCFBundleNameKey] as? String) ?? ""
    var countryCode: String?
    var forceLanguageLocalization: SirenLanguageType?
    
    var alertType = SirenAlertType.Option
    var majorUpdateAlertType: SirenAlertType?
    var minorUpdateAlertType: SirenAlertType?
    var patchUpdateAlertType: SirenAlertType?
    
    var presentingViewController: UIViewController?
    var alertControllerTintColor: UIColor?
    
    // Class Variables (Private)
    private var appData: [String : AnyObject]?
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
    func checkVersion(checkType: SirenVersionCheckType) {

        if (appID == nil || presentingViewController == nil) {
            println("[Siren]: Please make sure that you have set 'appID' and 'presentingViewController' before calling checkVersion.")
        } else {
            
            setupAlertTypes()
            
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
        
        let itunesURL = iTunesURLFromString()
        let request = NSMutableURLRequest(URL: itunesURL)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if data.length > 0 {
                self.appData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                if self.debugEnabled {
                    println("[Siren] JSON Results: \(self.appData!)");
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Store version comparison date
                    self.lastVersionCheckPerformedOnDate = NSUserDefaults.standardUserDefaults().objectForKey(self.sirenDefaultStoredVersionCheckDate) as? NSDate
                    NSUserDefaults.standardUserDefaults().setObject(self.lastVersionCheckPerformedOnDate, forKey: self.sirenDefaultStoredVersionCheckDate)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // Extract all versions that have been uploaded to the AppStore
                    if let data = self.appData {
                        self.currentAppStoreVersion = data["results"]?[0]["version"] as? String
                        if let currentAppStoreVersion = self.currentAppStoreVersion {
                            self.checkIfAppStoreVersionIsNewestVersion()
                        }
                    }
                })
            } else if self.debugEnabled {
                println("[Siren] Error Retrieving App Store Data: \(error!)")
            }
        })
        task.resume()
    }
    
    // MARK: Helpers
    
    func setupAlertTypes() {
        majorUpdateAlertType = alertType
        minorUpdateAlertType = alertType
        patchUpdateAlertType = alertType
    }
    
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
    
    func checkIfAppStoreVersionIsNewestVersion() {
        
        // Check if current installed version is the newest public version or newer (e.g., dev version)
        if let currentInstalledVersion = currentVersion {
            if (currentInstalledVersion.compare(currentAppStoreVersion!, options: .NumericSearch) == NSComparisonResult.OrderedAscending) {
                alertType = fetchAlertType()
                showAlertIfCurrentAppStoreVersionNotSkipped()
            }
        }
    }
    
    func fetchAlertType() -> SirenAlertType {
        
        // Set alert type for current version. Strings that don't represent numbers are treated as 0.
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
    
    var useAlertController: Bool {
      return objc_getClass("UIAlertController") != nil
    }
    
    // MARK: Alert
    func showAlertIfCurrentAppStoreVersionNotSkipped() {
        
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
        let newVersionMessageToLocalize = "A new version of %@ is available. Please update to version %@ now."
        var newVersionMessage = NSBundle().localizedString(newVersionMessageToLocalize, forceLanguageLocalization: forceLanguageLocalization)
        newVersionMessage = String(format: newVersionMessage!, appName, currentAppStoreVersion!)
        
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
            let updateButtonText = NSBundle().localizedString("Update", forceLanguageLocalization: forceLanguageLocalization)
            let nextTimeButtonText = NSBundle().localizedString("Next time", forceLanguageLocalization: forceLanguageLocalization)
            let skipButtonText = NSBundle().localizedString("Skip this version", forceLanguageLocalization: forceLanguageLocalization)
            switch alertType {
            case .Force:
                alertView = UIAlertView(title: updateAvailableMessage, message: newVersionMessage, delegate: self, cancelButtonTitle: updateButtonText!)
            case .Option:
                alertView = UIAlertView(title: updateAvailableMessage, message: newVersionMessage, delegate: self, cancelButtonTitle: nextTimeButtonText!)
                alertView!.addButtonWithTitle(updateButtonText!)
            case .Skip:
                alertView = UIAlertView(title: updateAvailableMessage, message: newVersionMessage, delegate: self, cancelButtonTitle: skipButtonText!)
                alertView!.addButtonWithTitle(updateButtonText!)
                alertView!.addButtonWithTitle(nextTimeButtonText!)
            case .None:
                return
            }
            
            if let alertView = alertView {
                alertView.show()
            }
        }
    }
    
    func updateAlertAction() -> UIAlertAction {
        let title = NSBundle().localizedString("Update", forceLanguageLocalization: forceLanguageLocalization)
        let action = UIAlertAction(title: title!, style: .Default) { (alert: UIAlertAction!) -> Void in
            self.launchAppStore()
            self.delegate?.sirenUserDidLaunchAppStore?()
            return
        }
        
        return action
    }
    
    func nextTimeAlertAction() -> UIAlertAction {
        let title = NSBundle().localizedString("Next time", forceLanguageLocalization: forceLanguageLocalization)
        let action = UIAlertAction(title: title!, style: .Default) { (alert: UIAlertAction!) -> Void in
            self.delegate?.sirenUserDidCancel?()
            return
        }
        
        return action
    }
    
    func skipAlertAction() -> UIAlertAction {
        let title = NSBundle().localizedString("Skip this version", forceLanguageLocalization: forceLanguageLocalization)
        let action = UIAlertAction(title: title!, style: .Default) { (alert: UIAlertAction!) -> Void in
            self.delegate?.sirenUserDidSkipVersion?()
            return
        }
        
        return action
    }
    
    // MARK: Actions
    func launchAppStore() {
        let iTunesString =  "https://itunes.apple.com/app/id\(appID)";
        let iTunesURL = NSURL(string: iTunesString);
        UIApplication.sharedApplication().openURL(iTunesURL!);
    }
}

// MARK: Extensions
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
