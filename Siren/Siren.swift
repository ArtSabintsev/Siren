//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

// MARK: SirenDelegate Protocol
@objc public protocol SirenDelegate {
    optional func sirenDidShowUpdateDialog()                            // User presented with update dialog
    optional func sirenUserDidLaunchAppStore()                          // User did click on button that launched App Store.app
    optional func sirenUserDidSkipVersion()                             // User did click on button that skips version update
    optional func sirenUserDidCancel()                                  // User did click on button that cancels update dialog
    optional func sirenDidDetectNewVersionWithoutAlert(message: String) // Siren performed version check and did not display alert
}

// MARK: Enumerations
/**
    Determines the type of alert to present after a successful version check has been performed.
    
    There are four options:
        - Force: Forces user to update your app (1 button alert)
        - Option: (DEFAULT) Presents user with option to update app now or at next launch (2 button alert)
        - Skip: Presents user with option to update the app now, at next launch, or to skip this version all together (3 button alert)
        - None: Doesn't show the alert, but instead returns a localized message for use in a custom UI within the sirenDidDetectNewVersionWithoutAlert() delegate method

*/
public enum SirenAlertType {
    case Force        // Forces user to update your app (1 button alert)
    case Option       // (DEFAULT) Presents user with option to update app now or at next launch (2 button alert)
    case Skip         // Presents user with option to update the app now, at next launch, or to skip this version all together (3 button alert)
    case None         // Doesn't show the alert, but instead returns a localized message for use in a custom UI within the sirenDidDetectNewVersionWithoutAlert() delegate method
}

/**
    Determines the frequency in which the the version check is performed
    
    - .Immediately: Version check performed every time the app is launched
    - .Daily: Version check performedonce a day
    - .Weekly: Version check performed once a week

*/
public enum SirenVersionCheckType: Int {
    case Immediately = 0    // Version check performed every time the app is launched
    case Daily = 1          // Version check performed once a day
    case Weekly = 7         // Version check performed once a week
}

/**
    Determines the available languages in which the update message and alert button titles should appear.
    
    By default, the operating system's default lanuage setting is used. However, you can force a specific language
    by setting the forceLanguageLocalization property before calling checkVersion()

*/
public enum SirenLanguageType: String {
    case Arabic = "ar"
    case Basque = "eu"
    case ChineseSimplified = "zh-Hans"
    case ChineseTraditional = "zh-Hant"
    case Danish = "da"
    case Dutch = "nl"
    case English = "en"
    case Estonian = "et"
    case French = "fr"
    case Hebrew = "he"
    case Hungarian = "hu"
    case German = "de"
    case Italian = "it"
    case Japanese = "ja"
    case Korean = "ko"
    case Latvian = "lv"
    case Lithuanian = "lt"
    case Polish = "pl"
    case PortugueseBrazil = "pt"
    case PortuguesePortugal = "pt-PT"
    case Russian = "ru"
    case Slovenian = "sl"
    case Spanish = "es"
    case Swedish = "sv"
    case Thai = "th"
    case Turkish = "tr"
}

/** 
    Siren-specific NSUserDefault Keys
*/
private enum SirenUserDefaults: String {
    case StoredVersionCheckDate     // NSUserDefault key that stores the timestamp of the last version check
    case StoredSkippedVersion       // NSUserDefault key that stores the version that a user decided to skip
}

// MARK: Siren
/**
    The Siren Class.
    
    A singleton that is initialized using the sharedInstance() method.
*/
public class Siren: NSObject {

    // MARK: Constants
    // Current installed version of your app
    let currentInstalledVersion = NSBundle.mainBundle().currentInstalledVersion()
    
    // NSBundle path for localization
    let bundlePath = NSBundle.mainBundle().pathForResource("Siren", ofType: "Bundle")
    
    // MARK: Variables
    /**
        The SirenDelegate variable, which should be set if you'd like to be notified:
    
            - When a user views or interacts with the alert
                - sirenDidShowUpdateDialog()
                - sirenUserDidLaunchAppStore()
                - sirenUserDidSkipVersion()     
                - sirenUserDidCancel()
            - When a new version has been detected, and you would like to present a localized message in a custom UI
                - sirenDidDetectNewVersionWithoutAlert(message: String)
    
    */
    public weak var delegate: SirenDelegate?

    /**
        The debug flag, which is disabled by default.
    
        When enabled, a stream of println() statements are logged to your console when a version check is performed.
    */
    public lazy var debugEnabled = false
    
    // Alert Vars
    /**
        Determines the type of alert that should be shown.
    
        See the SirenAlertType enum for full details.
    */
    public var alertType = SirenAlertType.Option
        {
        didSet {
            majorUpdateAlertType = alertType
            minorUpdateAlertType = alertType
            patchUpdateAlertType = alertType
            revisionUpdateAlertType = alertType
        }
    }
    
    /**
    Determines the type of alert that should be shown for major version updates: A.b.c
    
    Defaults to SirenAlertType.Option.
    
    See the SirenAlertType enum for full details.
    */
    public var majorUpdateAlertType = SirenAlertType.Option
    
    /**
    Determines the type of alert that should be shown for minor version updates: a.B.c
    
    Defaults to SirenAlertType.Option.
    
    See the SirenAlertType enum for full details.
    */
    public var minorUpdateAlertType  = SirenAlertType.Option
    
    /**
    Determines the type of alert that should be shown for minor patch updates: a.b.C
    
    Defaults to SirenAlertType.Option.
    
    See the SirenAlertType enum for full details.
    */
    public var patchUpdateAlertType = SirenAlertType.Option
    
    /**
    Determines the type of alert that should be shown for revision updates: a.b.c.D
    
    Defaults to SirenAlertType.Option.
    
    See the SirenAlertType enum for full details.
    */
    public var revisionUpdateAlertType = SirenAlertType.Option
    
    // Required Vars
    /**
        The App Store / iTunes Connect ID for your app.
    */
    public var appID: String?
    
    // Optional Vars
    /**
        The name of your app. 
    
        By default, it's set to the name of the app that's stored in your plist.
    */
    public lazy var appName: String = (NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as? String) ?? ""
    
    /**
        The region or country of an App Store in which your app is available.
        
        By default, all version checks are performed against the US App Store.
        If your app is not available in the US App Store, you should set it to the identifier 
        of at least one App Store within which it is available.
    */
    public var countryCode: String?
    
    /**
        Overrides the default localization of a user's device when presenting the update message and button titles in the alert.
    
        See the SirenLanguageType enum for more details.
    */
    public var forceLanguageLocalization: SirenLanguageType?
    
    /**
        Overrides the tint color for UIAlertController.
    */
    public var alertControllerTintColor: UIColor?
    
    // Private
    private var lastVersionCheckPerformedOnDate: NSDate?
    private var currentAppStoreVersion: String?
    private var updaterWindow: UIWindow?
    
    // MARK: Initialization
    public class var sharedInstance: Siren {
        struct Singleton {
            static let instance = Siren()
        }
        
        return Singleton.instance
    }
    
    override init() {
        lastVersionCheckPerformedOnDate = NSUserDefaults.standardUserDefaults().objectForKey(SirenUserDefaults.StoredVersionCheckDate.rawValue) as? NSDate
    }
    
    // MARK: Check Version
    /**
        Checks the currently installed version of your app against the App Store.
        The default check is against the US App Store, but if your app is not listed in the US,
        you should set the `countryCode` property before calling this method. Please refer to the countryCode property for more information.
    
        - parameter checkType: The frequency in days in which you want a check to be performed. Please refer to the SirenVersionCheckType enum for more details.
    */
    public func checkVersion(checkType: SirenVersionCheckType) {
        
        guard let _ = appID else {
            print("[Siren] Please make sure that you have set 'appID' before calling checkVersion.")
            return
        }

        if checkType == .Immediately {
            performVersionCheck()
        } else {
            guard let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate else {
                performVersionCheck()
                return
            }
            
            if daysSinceLastVersionCheckDate(lastVersionCheckPerformedOnDate) >= checkType.rawValue {
                performVersionCheck()
            }
        }
    }
    
    private func performVersionCheck() {
        
        // Create Request
        let itunesURL = iTunesURLFromString()
        let request = NSMutableURLRequest(URL: itunesURL)
        request.HTTPMethod = "GET"
        
        // Perform Request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                if self.debugEnabled {
                    print("[Siren] Error retrieving App Store data as an error was returned: \(error.localizedDescription)")
                }
            } else {
                guard let data = data else {
                    if self.debugEnabled {
                        print("[Siren] Error retrieving App Store data as no data was returned.")
                    }
                    return
                }
                
                // Convert JSON data to Swift Dictionary of type [String: AnyObject]
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                    
                    guard let appData = jsonData as? [String: AnyObject] else {
                        if self.debugEnabled {
                            print("[Siren] Error parsing App Store JSON data.")
                        }
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // Print iTunesLookup results from appData
                        if self.debugEnabled {
                            print("[Siren] JSON results: \(appData)")
                        }
                        
                        // Process Results (e.g., extract current version on the AppStore)
                        self.processVersionCheckResults(appData)
                        
                    })
                    
                } catch let error as NSError {
                    if self.debugEnabled {
                        print("[Siren] Error retrieving App Store data as data was nil: \(error.localizedDescription)")
                    }
                }
            }
            
        })
        
        task.resume()
    }
    
    private func processVersionCheckResults(lookupResults: [String: AnyObject]) {
        
        // Store version comparison date
        storeVersionCheckDate()

        guard let results = lookupResults["results"] as? [[String: AnyObject]] else {
            if debugEnabled {
                print("[Siren] Error retrieving App Store verson number as there was no data returned")
            }
            return
        }
        
        if results.isEmpty == false { // Conditional that avoids crash when app not in App Store or appID mistyped
            currentAppStoreVersion = results[0]["version"] as? String
            guard let _ = currentAppStoreVersion else {
                if debugEnabled {
                    print("[Siren] Error retrieving App Store verson number as results[0] does not contain a 'version' key")
                }
                return
            }
            
            if isAppStoreVersionNewer() {
                showAlertIfCurrentAppStoreVersionNotSkipped()
            } else {
                if debugEnabled {
                    print("[Siren] App Store version of app is not newer")
                }
            }
           
        } else { // lookupResults does not contain any data as the returned array is empty
            if debugEnabled {
                print("[Siren] Error retrieving App Store verson number as results returns an empty array")
            }
        }
    }
}

// MARK: Alert
private extension Siren {
    func showAlertIfCurrentAppStoreVersionNotSkipped() {
        
        alertType = setAlertType()
        
        guard let previouslySkippedVersion = NSUserDefaults.standardUserDefaults().objectForKey(SirenUserDefaults.StoredSkippedVersion.rawValue) as? String else {
            showAlert()
            return
        }
        
        if let currentAppStoreVersion = currentAppStoreVersion {
            if currentAppStoreVersion != previouslySkippedVersion {
                showAlert()
            }
        }
    }
    
    func showAlert() {
        
        let updateAvailableMessage = NSBundle().localizedString("Update Available", forceLanguageLocalization: forceLanguageLocalization)
        let newVersionMessage = localizedNewVersionMessage()

        let alertController = UIAlertController(title: updateAvailableMessage, message: newVersionMessage, preferredStyle: .Alert)
        
        if let alertControllerTintColor = alertControllerTintColor {
            alertController.view.tintColor = alertControllerTintColor
        }
        
        switch alertType {
        case .Force:
            alertController.addAction(updateAlertAction())
        case .Option:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
        case .Skip:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
            alertController.addAction(skipAlertAction())
        case .None:
            delegate?.sirenDidDetectNewVersionWithoutAlert?(newVersionMessage)
        }
        
        if alertType != .None {
            alertController.show()
            delegate?.sirenDidShowUpdateDialog?()
        }
    }
    
    func updateAlertAction() -> UIAlertAction {
        let title = localizedUpdateButtonTitle()
        let action = UIAlertAction(title: title, style: .Default) { (alert: UIAlertAction) -> Void in
            self.hideWindow()
            self.launchAppStore()
            self.delegate?.sirenUserDidLaunchAppStore?()
            return
        }
        
        return action
    }
    
    func nextTimeAlertAction() -> UIAlertAction {
        let title = localizedNextTimeButtonTitle()
        let action = UIAlertAction(title: title, style: .Default) { (alert: UIAlertAction) -> Void in
            self.hideWindow()
            self.delegate?.sirenUserDidCancel?()
            return
        }
        
        return action
    }
    
    func skipAlertAction() -> UIAlertAction {
        let title = localizedSkipButtonTitle()
        let action = UIAlertAction(title: title, style: .Default) { (alert: UIAlertAction) -> Void in
            if let currentAppStoreVersion = self.currentAppStoreVersion {
                NSUserDefaults.standardUserDefaults().setObject(currentAppStoreVersion, forKey: SirenUserDefaults.StoredSkippedVersion.rawValue)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            self.hideWindow()
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
            print("[Siren] iTunes Lookup URL: \(storeURLString)")
        }
        
        return NSURL(string: storeURLString)!
    }
    
    func daysSinceLastVersionCheckDate(lastVersionCheckPerformedOnDate: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Day, fromDate: NSDate(), toDate: lastVersionCheckPerformedOnDate, options: [])
        return components.day
    }
    
    func isAppStoreVersionNewer() -> Bool {
        
        var newVersionExists = false
        
        if let currentInstalledVersion = currentInstalledVersion, currentAppStoreVersion = currentAppStoreVersion {
            if (currentInstalledVersion.compare(currentAppStoreVersion, options: .NumericSearch) == NSComparisonResult.OrderedAscending) {
                newVersionExists = true
            }
        }
        
        return newVersionExists
    }
    
    func storeVersionCheckDate() {
        lastVersionCheckPerformedOnDate = NSDate()
        if let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate {
            NSUserDefaults.standardUserDefaults().setObject(lastVersionCheckPerformedOnDate, forKey: SirenUserDefaults.StoredVersionCheckDate.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func setAlertType() -> SirenAlertType {
        
        guard let currentInstalledVersion = currentInstalledVersion, currentAppStoreVersion = currentAppStoreVersion else {
            return .Option
        }
        
        let oldVersion = (currentInstalledVersion).characters.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
        let newVersion = (currentAppStoreVersion).characters.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
        
        if 2...4 ~= oldVersion.count && oldVersion.count == newVersion.count {
            if newVersion[0] > oldVersion[0] { // A.b.c.d
                alertType = majorUpdateAlertType
            } else if newVersion[1] > oldVersion[1] { // a.B.c.d
                alertType = minorUpdateAlertType
            } else if newVersion.count > 2 && newVersion[2] > oldVersion[2] { // a.b.C.d
                alertType = patchUpdateAlertType
            } else if newVersion.count > 3 && newVersion[3] > oldVersion[3] { // a.b.c.D
                alertType = revisionUpdateAlertType
            }
        }
        
        return alertType
    }
    
    func hideWindow() {
        if let updaterWindow = updaterWindow {
            updaterWindow.hidden = true
            self.updaterWindow = nil
        }
    }
    
    // Actions
    func launchAppStore() {
        let iTunesString =  "https://itunes.apple.com/app/id\(appID!)"
        let iTunesURL = NSURL(string: iTunesString)
        UIApplication.sharedApplication().openURL(iTunesURL!)
    }
}

// MARK: UIAlertController
private extension UIAlertController {
    func show() {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindowLevelAlert + 1
        
        Siren.sharedInstance.updaterWindow = window
        
        window.makeKeyAndVisible()
        window.rootViewController!.presentViewController(self, animated: true, completion: nil)
    }
}

// MARK: String Localization
private extension Siren {
    func localizedNewVersionMessage() -> String {
        
        let newVersionMessageToLocalize = "A new version of %@ is available. Please update to version %@ now."
        let newVersionMessage = NSBundle().localizedString(newVersionMessageToLocalize, forceLanguageLocalization: forceLanguageLocalization)
        
        guard let currentAppStoreVersion = currentAppStoreVersion else {
            return String(format: newVersionMessage, appName, "Unknown")
        }
        
        return String(format: newVersionMessage, appName, currentAppStoreVersion)
    }
    
    func localizedUpdateButtonTitle() -> String {
        return NSBundle().localizedString("Update", forceLanguageLocalization: forceLanguageLocalization)
    }
    
    func localizedNextTimeButtonTitle() -> String {
        return NSBundle().localizedString("Next time", forceLanguageLocalization: forceLanguageLocalization)
    }
    
    func localizedSkipButtonTitle() -> String {
        return NSBundle().localizedString("Skip this version", forceLanguageLocalization: forceLanguageLocalization)
    }
}

// MARK: NSBundle Extension
private extension NSBundle {
    func currentInstalledVersion() -> String? {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
    }

    func sirenBundlePath() -> String {
        return NSBundle(forClass: Siren.self).pathForResource("Siren", ofType: "bundle") as String!
    }

    func sirenForcedBundlePath(forceLanguageLocalization: SirenLanguageType) -> String {
        let path = sirenBundlePath()
        let name = forceLanguageLocalization.rawValue
        return NSBundle(path: path)!.pathForResource(name, ofType: "lproj")!
    }

    func localizedString(stringKey: String, forceLanguageLocalization: SirenLanguageType?) -> String {
        var path: String
        let table = "SirenLocalizable"
        if let forceLanguageLocalization = forceLanguageLocalization {
            path = sirenForcedBundlePath(forceLanguageLocalization)
        } else {
            path = sirenBundlePath()
        }
        
        return NSBundle(path: path)!.localizedStringForKey(stringKey, value: stringKey, table: table)
    }
}
