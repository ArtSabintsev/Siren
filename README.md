# Siren 🚨

### Notify users when a new version of your app is available and prompt them to upgrade.

[![Travis CI Status](https://travis-ci.org/ArtSabintsev/Siren.svg?branch=master)](https://travis-ci.org/ArtSabintsev/Siren)

![Swift Support](https://img.shields.io/badge/Swift-4.2%2C%204.1%2C%203.2%2C%203.1%202.3-orange.svg) ![Documentation](https://github.com/ArtSabintsev/Siren/blob/master/docs/badge.svg)

[![CocoaPods](https://img.shields.io/cocoapods/v/Siren.svg)](https://cocoapods.org/pods/Siren)  [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)

---

## Table of Contents
- [About](https://github.com/ArtSabintsev/Siren#about)
- [Features](https://github.com/ArtSabintsev/Siren#features)
- [Screenshots](https://github.com/ArtSabintsev/Siren#screenshots)
- [Installation Instructions](https://github.com/ArtSabintsev/Siren#installation-instructions)
- [Example Code](https://github.com/ArtSabintsev/Siren#example-code)
- [Granular/Differentiated Version Management](https://github.com/ArtSabintsev/Siren#granular-version-update-management)
- [Delegates (Optional)](https://github.com/ArtSabintsev/Siren#optional-delegate-and-delegate-methods)
- [Localization](https://github.com/ArtSabintsev/Siren#localization)
- [Device Compatibility](https://github.com/ArtSabintsev/Siren#device-compatibility)
- [Testing Siren](https://github.com/ArtSabintsev/Siren#testing-siren)
- [App Store Review & Submissions](https://github.com/ArtSabintsev/Siren#app-store-submissions)
- [Phrased Releases](https://github.com/ArtSabintsev/Siren#phased-releases)
- [Words of Caution](https://github.com/ArtSabintsev/Siren#words-of-caution)
- [Ports](https://github.com/ArtSabintsev/Siren#ports)
- [Attribution](https://github.com/ArtSabintsev/Siren#created-and-maintained-by)
---

## About
**Siren** checks a user's currently installed version of your iOS app against the version that is currently available in the App Store.

If a new version is available, an alert can be presented to the user informing them of the newer version, and giving them the option to update the application. Alternatively, Siren can notify your app programmatically, enabling you to inform the user through alternative means, such as a custom interface.

- Siren is built to work with the [**Semantic Versioning**](https://semver.org/) system.
	- Semantic Versioning is a three number versioning system (e.g., 1.0.0)
	- Siren also supports two-number versioning (e.g., 1.0) and four-number versioning (e.g., 1.0.0.0)
- Siren is actively maintained by [**Arthur Sabintsev**](https://github.com/ArtSabintsev) and [**Aaron Brager**](https://twitter.com/getaaron)

### README Translations
- [**简体中文**](README.zh_CN.md) (by [**Daniel Hu**](https://www.jianshu.com/u/d8bbc4831623))

## Features
- [x] CocoaPods Support
- [x] Carthage Support
- [x] Swift Package Manager Support
- [x] Localized for 30+ languages (see [Localization](https://github.com/ArtSabintsev/Siren#localization))
- [x] Pre-Update Device Compatibility Check (see [Device Compatibility](https://github.com/ArtSabintsev/Siren#device-compatibility))
- [x] Three types of alerts (see [Screenshots](https://github.com/ArtSabintsev/Siren#screenshots))
- [x] Optional delegate methods (see [Delegates (Optional)](https://github.com/ArtSabintsev/Siren#optional-delegate-and-delegate-methods))
- [x] Unit Tests
- [x] Documentation can be found at http://sabintsev.com/Siren.

## Screenshots
- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `Siren.AlertType` enum.

<img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picForcedUpdate.png?raw=true" height="480"><img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picOptionalUpdate.png?raw=true" height="480"><img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picSkippedUpdate.png?raw=true" height="480">


## Installation Instructions

| Swift Version |  Branch Name  | Will Continue to Receive Updates?
| ------------- | ------------- |  -------------
| 4.2  | master | **Yes**
| 4.1  | swift4.1 | No
| 3.2  | swift3.2 | No
| 3.1  | swift3.1 | No
| 2.3  | swift2.3 | No  

### CocoaPods
```ruby
pod 'Siren' # Swift 4.2
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift4.1' # Swift 4.1
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift3.2' # Swift 3.2
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift3.1' # Swift 3.1
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift2.3' # Swift 2.3
```

### Carthage
```swift
github "ArtSabintsev/Siren" // Swift 4.2
github "ArtSabintsev/Siren", "swift4.1" // Swift 4.1
github "ArtSabintsev/Siren", "swift3.2" // Swift 3.2
github "ArtSabintsev/Siren", "swift3.1" // Swift 3.1
github "ArtSabintsev/Siren", "swift2.3" // Swift 2.3
```

### Swift Package Manager
```swift
.Package(url: "https://github.com/ArtSabintsev/Siren.git", majorVersion: 3)
```

## Example Code

Below is some commented sample code. Adapt this to meet your app's needs.

For a full list of optional settings/preferences, please refer to https://github.com/ArtSabintsev/Siren/blob/master/Example/Example/AppDelegate.swift in the Sample Project.

```Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	/* Siren code should go below window?.makeKeyAndVisible() */

	// Siren is a singleton
	let siren = Siren.shared

	// Optional: Defaults to .option
	siren.alertType = <#Siren.AlertType_Enum_Value#>

	// Optional: Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
	siren.alertMessaging = SirenAlertMessaging(updateTitle: NSAttributedString(string: "New Fancy Title"),
												updateMessage: NSAttributedString(string: "New message goes here!"),
												updateButtonMessage: NSAttributedString(string: "Update Now, Plz!?"),
												nextTimeButtonMessage: NSAttributedString(string: "OK, next time it is!"),
												skipVersionButtonMessage: NSAttributedString(string: "Please don't push skip, please don't!"))


	// Optional: Set this variable if you would only like to show an alert if your app has been available on the store for a few days.
	// This default value is set to 1 to avoid this issue: https://github.com/ArtSabintsev/Siren#words-of-caution
	// To show the update immediately after Apple has updated their JSON, set this value to 0. Not recommended due to aforementioned reason in https://github.com/ArtSabintsev/Siren#words-of-caution.
	siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 3

	// Replace .immediately with .daily or .weekly to specify a maximum daily or weekly frequency for version checks.
	// DO NOT CALL THIS METHOD IN didFinishLaunchingWithOptions IF YOU ALSO PLAN TO CALL IT IN applicationDidBecomeActive.
	siren.checkVersion(checkType: .immediately)

    return true
}

func applicationDidBecomeActive(application: UIApplication) {
	/*
	    Perform daily (.daily) or weekly (.weekly) checks for new version of your app.
	    Useful if user returns to your app from the background after extended period of time.
    	    Place in applicationDidBecomeActive(_:).
	 */

    Siren.shared.checkVersion(checkType: .daily)
}

func applicationWillEnterForeground(application: UIApplication) {
   /*
      Useful if user returns to your app from the background after being sent to the
      App Store, but doesn't update their app before coming back to your app.

      ONLY USE WITH Siren.AlertType.immediately
   */

    Siren.shared.checkVersion(checkType: .immediately)
}
```

And you're all set!

### Prompting for Updates without Alerts

Some developers may want to display a less obtrusive custom interface, like a banner or small icon. To accomplish this, you can disable alert presentation by doing the following:

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	...
	siren.delegate = self
	siren.alertType = .none
	...
}

extension AppDelegate: SirenDelegate {
	// Returns a localized message to this delegate method upon performing a successful version check
	func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType) {
	    print("\(message)")
	}
}
```

Siren will call the `sirenDidDetectNewVersionWithoutAlert(message: String)` delegate method, passing a localized, suggested update string suitable for display. Implement this method to display your own messaging, optionally using `message`.

## Granular Version Update Management
If you would like to set a different type of alert for revision, patch, minor, and/or major updates, simply add one or all of the following *optional* lines to your setup *before* calling the `checkVersion()` method:

```swift
	/* Siren defaults to Siren.AlertType.option for all updates */
	siren.shared.revisionUpdateAlertType = <#Siren.AlertType_Enum_Value#>
	siren.shared.patchUpdateAlertType = <#Siren.AlertType_Enum_Value#>
	siren.shared.minorUpdateAlertType = <#Siren.AlertType_Enum_Value#>
	siren.shared.majorUpdateAlertType = <#Siren.AlertType_Enum_Value#>
```

## Optional Delegate and Delegate Methods
Six delegate methods allow you to handle or track the user's behavior. Each method has a default, empty implementation, effectively making each of these methods optional.

```	swift
public protocol SirenDelegate: NSObjectProtocol {
	/// Siren performed version check and did not display alert.
	func sirenDidDetectNewVersionWithoutAlert(message: String, updateType: UpdateType)

	/// Siren failed to perform version check.
	///
	/// - Note:
	///     Depending on the reason for failure,
	///     a system-level error may be returned.
	func sirenDidFailVersionCheck(error: Error)

	/// User presented with update dialog.
	func sirenDidShowUpdateDialog(alertType: Siren.AlertType)

	/// Siren performed a version check and latest version is installed.
	func sirenLatestVersionInstalled()

	/// Provides the decoded JSON information from a successful version check call.
	///
	/// - SeeAlso:
	///     SirenLookupModel.swift
	///
	/// - Parameter lookupModel: The `Decodable` model representing the JSON results from the iTunes Lookup API.
	func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel)

	/// User did click on button that cancels update dialog.
	func sirenUserDidCancel()

	/// User did click on button that launched "App Store.app".
	func sirenUserDidLaunchAppStore()

	/// User did click on button that skips version update.
	func sirenUserDidSkipVersion()
}
```

## Localization
Siren is localized for
- Arabic
- Armenian
- Basque
- Chinese (Simplified and Traditional)
- Croatian
- Czech
- Danish
- Dutch
- English
- Estonian
- Finnish
- French
- German
- Greek
- Hebrew
- Hungarian
- Indonesian
- Italian
- Japanese
- Korean
- Latvian
- Lithuanian
- Malay
- Norwegian (Bokmål)
- Persian (Afghanistan, Iran, Persian)
- Polish
- Portuguese (Brazil and Portugal)
- Russian
- Serbian (Cyrillic and Latin)
- Slovenian
- Spanish
- Swedish
- Thai
- Turkish
- Ukrainian
- Urdu
- Vietnamese

You may want the update dialog to *always* appear in a certain language, ignoring iOS's language setting (e.g. apps released in a specific country).

You can enable it like so:

```swift
Siren.shared.forceLanguageLocalization = Siren.LanguageType.<#Siren.LanguageType_Enum_Value#>
```
## Device Compatibility
If an app update is available, Siren checks to make sure that the version of iOS on the user's device is compatible with the one that is required by the app update. For example, if a user has iOS 10 installed on their device, but the app update requires iOS 11, an alert will not be shown. This takes care of the *false positive* case regarding app updating.

## Testing Siren
Temporarily change the version string in Xcode (within the `.xcodeproj`) to an older version than the one that's currently available in the App Store. Afterwards, build and run your app, and you should see the alert.

If you currently don't have an app in the store, change your bundleID to one that is already in the store. In the sample app packaged with this library, we use the [App Store Connect](https://itunes.apple.com/app/id1234793120) app's bundleID: `com.apple.AppStoreConnect`.

For your convenience, you may turn on debugging statements by setting `self.debugEnabled = true` before calling the `checkVersion()` method.

## App Store Submissions
The App Store reviewer will **not** see the alert. The version in the App Store will always be older than the version being reviewed.

## Phased Releases
In 2017, Apple announced the [ability to rollout app updates gradually (a.k.a. Phased Releases)](https://itunespartner.apple.com/en/apps/faq/Managing%20Your%20Apps_Submission%20Process). Siren will continue to work as it has in the past, presenting an update modal to _all_ users. If you opt-in to a phased rollout for a specific version, you have a few choices:

- You can leave Siren configured as normal. Phased rollout will continue to auto-update apps. Since all users can still manually update your app directly from the App Store, Siren will ignore the phased rollout and will prompt users to update.
- You can set `showAlertAfterCurrentVersionHasBeenReleasedForDays` to `7`, and Siren will not prompt any users until the latest version is 7 days old, after phased rollout is complete.
- You can remotely disable Siren until the rollout is done using your own API / backend logic.

## Words of Caution
Occasionally, the iTunes JSON will update faster than the App Store CDN, meaning the JSON may state that the new version of the app has been released, while no new binary is made available for download via the App Store. It is for this reason that Siren will, by default, wait 1 day (24 hours) after the JSON has been updated to prompt the user to update. To change the default setting, please modify the value of `showAlertAfterCurrentVersionHasBeenReleasedForDays`.

## Ports
- **Objective-C (iOS)**
   - [**Harpy**](https://github.com/ArtSabintsev/Harpy)
   - Siren was ported _from_ Harpy, as Siren and Harpy are maintained by the same developer.
- **Java (Android)**
   - [**Egghead Games' Siren library**](https://github.com/eggheadgames/Siren)
   - The Siren Swift library inspired the Java library.
- **React Native (iOS)**
   - [**Gant Laborde's Siren library**](https://github.com/GantMan/react-native-siren)
   - The Siren Swift library inspired the React Native library.

## Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/) & [Aaron Brager](https://twitter.com/getaaron)
