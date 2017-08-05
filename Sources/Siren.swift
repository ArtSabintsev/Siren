//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

// MARK: - Siren

/// The Siren Class. A singleton that is initialized using the shared() method.
public final class Siren: NSObject {

    /// Current installed version of your app.
    internal var currentInstalledVersion: String? = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }()

    /// The error domain for all errors created by Siren.
    public let SirenErrorDomain = "Siren Error Domain"

    /// The SirenDelegate variable, which should be set if you'd like to be notified:
    ///
    /// When a user views or interacts with the alert
    /// - sirenDidShowUpdateDialog(alertType: AlertType)
    /// - sirenUserDidLaunchAppStore()
    /// - sirenUserDidSkipVersion()
    /// - sirenUserDidCancel()
    ///
    /// When a new version has been detected, and you would like to present a localized message in a custom UI. use this delegate method:
    /// - sirenDidDetectNewVersionWithoutAlert(message: String)
    public weak var delegate: SirenDelegate?

    /// The debug flag, which is disabled by default.
    /// When enabled, a stream of print() statements are logged to your console when a version check is performed.
    public lazy var debugEnabled = false

    /// Determines the type of alert that should be shown.
    /// See the Siren.AlertType enum for full details.
    public var alertType = AlertType.option {
        didSet {
            majorUpdateAlertType = alertType
            minorUpdateAlertType = alertType
            patchUpdateAlertType = alertType
            revisionUpdateAlertType = alertType
        }
    }

    /// Determines the type of alert that should be shown for major version updates: A.b.c
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var majorUpdateAlertType = AlertType.option

    /// Determines the type of alert that should be shown for minor version updates: a.B.c
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var minorUpdateAlertType  = AlertType.option

    /// Determines the type of alert that should be shown for minor patch updates: a.b.C
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var patchUpdateAlertType = AlertType.option

    /// Determines the type of alert that should be shown for revision updates: a.b.c.D
    /// Defaults to Siren.AlertType.option.
    /// See the Siren.AlertType enum for full details.
    public lazy var revisionUpdateAlertType = AlertType.option

    /// The name of your app.
    /// By default, it's set to the name of the app that's stored in your plist.
    public lazy var appName: String = Bundle.main.bestMatchingAppName()

    /// The region or country of an App Store in which your app is available.
    /// By default, all version checks are performed against the US App Store.
    /// If your app is not available in the US App Store, set it to the identifier of at least one App Store within which it is available.
    public var countryCode: String?

    /// Overrides the default localization of a user's device when presenting the update message and button titles in the alert.
    /// See the Siren.LanguageType enum for more details.
    public var forceLanguageLocalization: Siren.LanguageType?

    /// Overrides the tint color for UIAlertController.
    public var alertControllerTintColor: UIColor?

    /// When this is set, the alert will only show up if the current version has already been released for X days
    /// Defaults to 1 day to avoid an issue where Apple updates the JSON faster than the app binary propogates to the App Store.
    public var showAlertAfterCurrentVersionHasBeenReleasedForDays: Int = 1

    /// The current version of your app that is available for download on the App Store
    public internal(set) var currentAppStoreVersion: String?

    internal var updaterWindow: UIWindow?
    fileprivate var appID: Int?
    fileprivate var lastVersionCheckPerformedOnDate: Date?
    fileprivate lazy var alertViewIsVisible: Bool = false

    /// The App's Singleton
    public static let shared = Siren()

    @available(*, deprecated: 1.2.0, unavailable, renamed: "shared")
    public static let sharedInstance = Siren()

    override init() {
        lastVersionCheckPerformedOnDate = UserDefaults.standard.object(forKey: SirenDefaults.StoredVersionCheckDate.rawValue) as? Date
    }

    /// Checks the currently installed version of your app against the App Store.
    /// The default check is against the US App Store, but if your app is not listed in the US,
    /// you should set the `countryCode` property before calling this method. Please refer to the countryCode property for more information.
    ///
    /// - Parameters:
    ///   - checkType: The frequency in days in which you want a check to be performed. Please refer to the Siren.VersionCheckType enum for more details.
    public func checkVersion(checkType: VersionCheckType) {
        guard let _ = Bundle.bundleID() else {
            printMessage("Please make sure that you have set a `Bundle Identifier` in your project.")
            return
        }

        if checkType == .immediately {
            performVersionCheck()
        } else {
            guard let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate else {
                performVersionCheck()
                return
            }

            if Date.days(since: lastVersionCheckPerformedOnDate) >= checkType.rawValue {
                performVersionCheck()
            } else {
                postError(.recentlyCheckedAlready, underlyingError: nil)
            }
        }
    }

    /// Launches the AppStore in two situations:
    /// 
    /// - User clicked the `Update` button in the UIAlertController modal.
    /// - Developer built a custom alert modal and needs to be able to call this function when the user chooses to update the app in the aforementioned custom modal.
    public func launchAppStore() {
        guard let appID = appID,
            let iTunesURL = URL(string: "https://itunes.apple.com/app/id\(appID)") else {
                return
        }

        DispatchQueue.main.async {
            UIApplication.shared.openURL(iTunesURL)
        }
    }

}

// MARK: - Helpers (Networking)

private extension Siren {

    func performVersionCheck() {
        do {
            let url = try iTunesURLFromString()
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request, completionHandler: { [unowned self] (data, response, error) in
                self.processResults(withData: data, response: response, error: error)
            }).resume()
        } catch let error as NSError {
            postError(.malformedURL, underlyingError: error)
        }
    }

    func processResults(withData data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            postError(.appStoreDataRetrievalFailure, underlyingError: error)
        } else {
            guard let data = data else {
                postError(.appStoreDataRetrievalFailure, underlyingError: nil)
                return
            }

            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                guard let appData = jsonData as? [String: Any],
                    isUpdateCompatibleWithDeviceOS(appData: appData) else {
                        postError(.appStoreJSONParsingFailure, underlyingError: nil)
                        return
                }

                DispatchQueue.main.async { [unowned self] in
                    // Print iTunesLookup results from appData
                    self.printMessage("JSON results: \(appData)")

                    // Process Results (e.g., extract current version that is available on the AppStore)
                    self.processVersionCheck(with: appData)
                }

            } catch let error as NSError {
                postError(.appStoreDataRetrievalFailure, underlyingError: error)
            }
        }
    }

    func processVersionCheck(with payload: [String: Any]) {
        storeVersionCheckDate() // Store version comparison date

        guard let results = payload[JSONKeys.results] as? [[String: Any]] else {
            postError(.appStoreVersionNumberFailure, underlyingError: nil)
            return
        }

        /// Condition satisfied when app not in App Store
        guard !results.isEmpty else {
            postError(.appStoreDataRetrievalFailure, underlyingError: nil)
            return
        }

        guard let info = results.first else {
            postError(.appStoreDataRetrievalFailure, underlyingError: nil)
            return
        }

        guard let appID = info[JSONKeys.appID] as? Int else {
            postError(.appStoreAppIDFailure, underlyingError: nil)
            return
        }

        self.appID = appID

        guard let currentAppStoreVersion = info[JSONKeys.version] as? String else {
            postError(.appStoreVersionArrayFailure, underlyingError: nil)
            return
        }

        self.currentAppStoreVersion = currentAppStoreVersion

        guard isAppStoreVersionNewer() else {
            delegate?.sirenLatestVersionInstalled()
            postError(.noUpdateAvailable, underlyingError: nil)
            return
        }

        guard let currentVersionReleaseDate = info[JSONKeys.currentVersionReleaseDate] as? String,
            let daysSinceRelease = Date.days(since: currentVersionReleaseDate) else {
            return
        }

        guard daysSinceRelease >= showAlertAfterCurrentVersionHasBeenReleasedForDays else {
            let message = "Your app has been released for \(daysSinceRelease) days, but Siren cannot prompt the user until \(showAlertAfterCurrentVersionHasBeenReleasedForDays) days have passed."
            self.printMessage(message)
            return
        }

        showAlertIfCurrentAppStoreVersionNotSkipped()
    }

    func iTunesURLFromString() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        var items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.bundleID())]

        if let countryCode = countryCode {
            let item = URLQueryItem(name: "country", value: countryCode)
            items.append(item)
        }

        components.queryItems = items

        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw SirenError.malformedURL
        }

        return url
    }
}

// MARK: - Helpers (Alert)

private extension Siren {
    func showAlertIfCurrentAppStoreVersionNotSkipped() {
        alertType = setAlertType()

        guard let previouslySkippedVersion = UserDefaults.standard.object(forKey: SirenDefaults.StoredSkippedVersion.rawValue) as? String else {
            showAlert()
            return
        }

        if let currentAppStoreVersion = currentAppStoreVersion, currentAppStoreVersion != previouslySkippedVersion {
            showAlert()
        }
    }

    func showAlert() {
        let updateAvailableMessage = Bundle().localizedString(stringKey: "Update Available", forceLanguageLocalization: forceLanguageLocalization)
        let newVersionMessage = localizedNewVersionMessage()

        let alertController = UIAlertController(title: updateAvailableMessage, message: newVersionMessage, preferredStyle: .alert)

        if let alertControllerTintColor = alertControllerTintColor {
            alertController.view.tintColor = alertControllerTintColor
        }

        switch alertType {
        case .force:
            alertController.addAction(updateAlertAction())
        case .option:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
        case .skip:
            alertController.addAction(nextTimeAlertAction())
            alertController.addAction(updateAlertAction())
            alertController.addAction(skipAlertAction())
        case .none:
            delegate?.sirenDidDetectNewVersionWithoutAlert(message: newVersionMessage)
        }

        if alertType != .none && !alertViewIsVisible {
            alertController.show()
            alertViewIsVisible = true
            delegate?.sirenDidShowUpdateDialog(alertType: alertType)
        }
    }

    func updateAlertAction() -> UIAlertAction {
        let title = localizedUpdateButtonTitle()
        let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.hideWindow()
            self.launchAppStore()
            self.delegate?.sirenUserDidLaunchAppStore()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func nextTimeAlertAction() -> UIAlertAction {
        let title = localizedNextTimeButtonTitle()
        let action = UIAlertAction(title: title, style: .default) { [unowned self] _  in
            self.hideWindow()
            self.delegate?.sirenUserDidCancel()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func skipAlertAction() -> UIAlertAction {
        let title = localizedSkipButtonTitle()
        let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in

            if let currentAppStoreVersion = self.currentAppStoreVersion {
                UserDefaults.standard.set(currentAppStoreVersion, forKey: SirenDefaults.StoredSkippedVersion.rawValue)
                UserDefaults.standard.synchronize()
            }

            self.hideWindow()
            self.delegate?.sirenUserDidSkipVersion()
            self.alertViewIsVisible = false
            return
        }

        return action
    }

    func setAlertType() -> Siren.AlertType {
        guard let currentInstalledVersion = currentInstalledVersion,
            let currentAppStoreVersion = currentAppStoreVersion else {
                return .option
        }

        let oldVersion = (currentInstalledVersion).characters.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
        let newVersion = (currentAppStoreVersion).characters.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}

        guard let newVersionFirst = newVersion.first, let oldVersionFirst = oldVersion.first else {
            return alertType // Default value is .Option
        }

        if newVersionFirst > oldVersionFirst { // A.b.c.d
            alertType = majorUpdateAlertType
        } else if newVersion.count > 1 && (oldVersion.count <= 1 || newVersion[1] > oldVersion[1]) { // a.B.c.d
            alertType = minorUpdateAlertType
        } else if newVersion.count > 2 && (oldVersion.count <= 2 || newVersion[2] > oldVersion[2]) { // a.b.C.d
            alertType = patchUpdateAlertType
        } else if newVersion.count > 3 && (oldVersion.count <= 3 || newVersion[3] > oldVersion[3]) { // a.b.c.D
            alertType = revisionUpdateAlertType
        }

        return alertType
    }
}

// MARK: - Helpers (Localization)

private extension Siren {
    func localizedNewVersionMessage() -> String {
        let newVersionMessageToLocalize = "A new version of %@ is available. Please update to version %@ now."
        let newVersionMessage = Bundle().localizedString(stringKey: newVersionMessageToLocalize, forceLanguageLocalization: forceLanguageLocalization)

        guard let currentAppStoreVersion = currentAppStoreVersion else {
            return String(format: newVersionMessage, appName, "Unknown")
        }

        return String(format: newVersionMessage, appName, currentAppStoreVersion)
    }

    func localizedUpdateButtonTitle() -> String {
        return Bundle().localizedString(stringKey: "Update", forceLanguageLocalization: forceLanguageLocalization)
    }

    func localizedNextTimeButtonTitle() -> String {
        return Bundle().localizedString(stringKey: "Next time", forceLanguageLocalization: forceLanguageLocalization)
    }

    func localizedSkipButtonTitle() -> String {
        return Bundle().localizedString(stringKey: "Skip this version", forceLanguageLocalization: forceLanguageLocalization)
    }
}

// MARK: - Helpers (Version)

extension Siren {
    func isAppStoreVersionNewer() -> Bool {
        var newVersionExists = false

        if let currentInstalledVersion = currentInstalledVersion,
            let currentAppStoreVersion = currentAppStoreVersion,
            (currentInstalledVersion.compare(currentAppStoreVersion, options: .numeric) == .orderedAscending) {

            newVersionExists = true
        }

        return newVersionExists
    }

    fileprivate func storeVersionCheckDate() {
        lastVersionCheckPerformedOnDate = Date()
        if let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate {
            UserDefaults.standard.set(lastVersionCheckPerformedOnDate, forKey: SirenDefaults.StoredVersionCheckDate.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}

// MARK: - Helpers (Misc.)

private extension Siren {
    func isUpdateCompatibleWithDeviceOS(appData: [String: Any]) -> Bool {
        guard let results = appData[JSONKeys.results] as? [[String: Any]],
            let info = results.first,
            let requiredOSVersion = info[JSONKeys.minimumOSVersion] as? String else {
                postError(.appStoreOSVersionNumberFailure, underlyingError: nil)
                return false
        }

        let systemVersion = UIDevice.current.systemVersion

        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame else {
            postError(.appStoreOSVersionUnsupported, underlyingError: nil)
            return false
        }

        return true
    }

    func hideWindow() {
        if let updaterWindow = updaterWindow {
            updaterWindow.isHidden = true
            self.updaterWindow = nil
        }
    }

    /// Routes a console-bound message to the `SirenLog` struct, which decorates the log message.
    ///
    /// - Parameter message: The message to decorate and log to the console.
    func printMessage(_ message: String) {
        if debugEnabled {
            SirenLog(message)
        }
    }
}

// MARK: - Enumerated Types (Public)

public extension Siren {
    /// Determines the type of alert to present after a successful version check has been performed.
    enum AlertType {
        /// Forces user to update your app (1 button alert).
        case force

        /// (DEFAULT) Presents user with option to update app now or at next launch (2 button alert).
        case option

        /// Presents user with option to update the app now, at next launch, or to skip this version all together (3 button alert).
        case skip

        /// Doesn't show the alert, but instead returns a localized message 
        /// for use in a custom UI within the sirenDidDetectNewVersionWithoutAlert() delegate method.
        case none
    }

    /// Determines the frequency in which the the version check is performed and the user is prompted to update the app.
    ///
    enum VersionCheckType: Int {
        /// Version check performed every time the app is launched.
        case immediately = 0

        /// Version check performed once a day.
        case daily = 1

        /// Version check performed once a week.
        case weekly = 7
    }

    /// Determines the available languages in which the update message and alert button titles should appear.
    ///
    /// By default, the operating system's default lanuage setting is used. However, you can force a specific language
    /// by setting the forceLanguageLocalization property before calling checkVersion()
    enum LanguageType: String {
        case Arabic = "ar"
        case Armenian = "hy"
        case Basque = "eu"
        case ChineseSimplified = "zh-Hans"
        case ChineseTraditional = "zh-Hant"
        case Croatian = "hr"
        case Czech = "cs"
        case Danish = "da"
        case Dutch = "nl"
        case English = "en"
        case Estonian = "et"
        case Finnish = "fi"
        case French = "fr"
        case German = "de"
        case Greek = "el"
        case Hebrew = "he"
        case Hungarian = "hu"
        case Indonesian = "id"
        case Italian = "it"
        case Japanese = "ja"
        case Korean = "ko"
        case Latvian = "lv"
        case Lithuanian = "lt"
        case Malay = "ms"
        case Norwegian = "nb-NO"
        case Persian = "fa"
        case PersianAfghanistan = "fa-AF"
        case PersianIran = "fa-IR"
        case Polish = "pl"
        case PortugueseBrazil = "pt"
        case PortuguesePortugal = "pt-PT"
        case Russian = "ru"
        case SerbianCyrillic = "sr-Cyrl"
        case SerbianLatin = "sr-Latn"
        case Slovenian = "sl"
        case Spanish = "es"
        case Swedish = "sv"
        case Thai = "th"
        case Turkish = "tr"
        case Urdu = "ur"
        case Vietnamese = "vi"
    }
}

// MARK: - Enumerated Types (Private)

private extension Siren {
    /// Siren-specific Error Codes
    enum ErrorCode: Int {
        case malformedURL = 1000
        case recentlyCheckedAlready
        case noUpdateAvailable
        case appStoreDataRetrievalFailure
        case appStoreJSONParsingFailure
        case appStoreOSVersionNumberFailure
        case appStoreOSVersionUnsupported
        case appStoreVersionNumberFailure
        case appStoreVersionArrayFailure
        case appStoreAppIDFailure
        case appStoreReleaseDateFailure
    }

    /// Siren-specific Throwable Errors
    enum SirenError: Error {
        case malformedURL
        case missingBundleIdOrAppId
    }

    /// Siren-specific UserDefaults Keys
    enum SirenDefaults: String {
        /// Key that stores the timestamp of the last version check in UserDefaults
        case StoredVersionCheckDate

        /// Key that stores the version that a user decided to skip in UserDefaults.
        case StoredSkippedVersion
    }

    struct JSONKeys {
        static let appID = "trackId"
        static let currentVersionReleaseDate = "currentVersionReleaseDate"
        static let minimumOSVersion = "minimumOsVersion"
        static let results = "results"
        static let version = "version"
    }

}

// MARK: - Error Handling

private extension Siren {
    func postError(_ code: ErrorCode, underlyingError: Error?) {
        let description: String

        switch code {
        case .malformedURL:
            description = "The iTunes URL is malformed. Please leave an issue on http://github.com/ArtSabintsev/Siren with as many details as possible."
        case .recentlyCheckedAlready:
            description = "Not checking the version, because it already checked recently."
        case .noUpdateAvailable:
            description = "No new update available."
        case .appStoreDataRetrievalFailure:
            description = "Error retrieving App Store data as an error was returned."
        case .appStoreJSONParsingFailure:
            description = "Error parsing App Store JSON data."
        case .appStoreOSVersionNumberFailure:
            description = "Error retrieving iOS version number as there was no data returned."
        case .appStoreOSVersionUnsupported:
            description = "The version of iOS on the device is lower than that of the one required by the app verison update."
        case .appStoreVersionNumberFailure:
            description = "Error retrieving App Store version number as there was no data returned."
        case .appStoreVersionArrayFailure:
            description = "Error retrieving App Store verson number as the JSON does not contain a 'version' key."
        case .appStoreAppIDFailure:
            description = "Error retrieving trackId as the JSON does not contain a 'trackId' key."
        case .appStoreReleaseDateFailure:
            description = "Error retrieving trackId as the JSON does not contain a 'currentVersionReleaseDate' key."
        }

        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: description]

        if let underlyingError = underlyingError {
            userInfo[NSUnderlyingErrorKey] = underlyingError
        }

        let error = NSError(domain: SirenErrorDomain, code: code.rawValue, userInfo: userInfo)

        delegate?.sirenDidFailVersionCheck(error: error)

        printMessage(error.localizedDescription)
    }
}
