# Siren

### Notify users when a new version of your app is available and prompt them to upgrade.

![Travis-CI](https://travis-ci.org/ArtSabintsev/Siren.svg?branch=master) ![Cocoapods](https://img.shields.io/cocoapods/v/Siren.svg) ![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat) ![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)
---

## About
**Siren** checks a user's currently installed version of your iOS app against the version that is currently available in the App Store.

If a new version is available, an alert can be presented to the user informing them of the newer version, and giving them the option to update the application. Alternatively, Siren can notify your app programmatically, enabling you to inform the user through alternative means, such as a custom interface.

- Siren is built to work with the [**Semantic Versioning**](http://semver.org/) system.
	- Semantic Versioning is a three number versioning system (e.g., 1.0.0)
	- Siren also supports two-number versioning (e.g., 1.0)
	- Siren also supports four-number versioning (e.g., 1.0.0.0)
- Siren is actively maintained by [**Arthur Sabintsev**](http://github.com/ArtSabintsev) and [**Aaron Brager**](http://twitter.com/getaaron)

## Ports
- Siren is a Swift language port of [**Harpy**](http://github.com/ArtSabintsev/Harpy), an Objective-C library that achieves the same functionality.
- Siren and Harpy are maintained by the same developers.
- This library was the inspiration for [**Egghead Games' Siren library**](https://github.com/eggheadgames/Siren), which achieves the same functionality with the Google Play store on the Android platform.
- This library was the inspiration for [**Gant Laborde's Siren library**](https://github.com/GantMan/react-native-siren), which achieves the same functionality for React Native projects (iOS/Android).

## Features
- [x] CocoaPods Support
- [x] Carthage Support
- [x] Swift Package Manager Support
- [x] Localized for 20+ languages (See **Localization**)
- [x] Pre-Update Device Compatibility Check (See **Device Compatibility**)
- [x] Three types of alerts (see **Screenshots**)
- [x] Optional delegate methods (see **Optional Delegate**)
- [x] Unit Tests!

## Screenshots

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `SirenAlertType` enum.

<img src="https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picForcedUpdate.png?raw=true" height=480">
<img src="https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picOptionalUpdate.png?raw=true" height=480">
<img src="https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picSkippedUpdate.png?raw=true" height=480">


## Installation Instructions

### CocoaPods
For Swift 3 support:
```ruby
pod 'Siren'
```

For Swift 2.3 support:

```ruby
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift2.3'
```

For Swift 2.2 support:

```ruby
pod 'Siren', '0.9.5'
```

### Carthage
For Swift 3 support:

``` swift
github "ArtSabintsev/Siren"
```

For Swift 2.3 support:

``` swift
github "ArtSabintsev/Siren" "swift2.3"
```

### Swift Package Manager
```swift
.Package(url: "https://github.com/ArtSabintsev/Siren.git", majorVersion: 1)
```

## Setup

Here's some commented sample code. Adapt this to meet your app's needs. For a full list of optional settings/preferences, please refer to https://github.com/ArtSabintsev/Siren/blob/master/Sample%20App/Sample%20App/AppDelegate.swift in the Sample Project.

```Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	/* Siren code should go below window?.makeKeyAndVisible() */

	// Siren is a singleton
	let siren = Siren.sharedInstance

	// Optional: Defaults to .Option
	siren.alertType = <#SirenAlertType_Enum_Value#>

	/*
	    Replace .Immediately with .Daily or .Weekly to specify a maximum daily or weekly frequency for version
	    checks.
	*/
    siren.checkVersion(.Immediately)

    return true
}

func applicationDidBecomeActive(application: UIApplication) {
	/*
	    Perform daily (.Daily) or weekly (.Weekly) checks for new version of your app.
	    Useful if user returns to your app from the background after extended period of time.
    	 Place in applicationDidBecomeActive(_:).	*/

    Siren.sharedInstance.checkVersion(.Daily)
}

func applicationWillEnterForeground(application: UIApplication) {
   /*
	    Useful if user returns to your app from the background after being sent to the
	    App Store, but doesn't update their app before coming back to your app.

       ONLY USE WITH SirenAlertType.Force
   */

    Siren.sharedInstance.checkVersion(.Immediately)
}
```

And you're all set!

### Prompting for Updates without Alerts

Some developers may want to display a less obtrusive custom interface, like a banner or small icon. To accomplish this, you can disable alert presentation by doing the following:

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	...
	siren.delegate = self
	siren.alertType = .None
	...
}

extension AppDelegate: SirenDelegate {
	// Returns a localized message to this delegate method upon performing a successful version check
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print("\(message)")
    }
}
```

Siren will call the `sirenDidDetectNewVersionWithoutAlert(message: String)` delegate method, passing a localized, suggested update string suitable for display. Implement this method to display your own messaging, optionally using `message`.

## Differentiated Alerts for Revision, Patch, Minor, and Major Updates
If you would like to set a different type of alert for revision, patch, minor, and/or major updates, simply add one or all of the following *optional* lines to your setup *before* calling the `checkVersion()` method:

```swift
	/* Siren defaults to SirenAlertType.Option for all updates */
	siren.sharedInstance().revisionUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().patchUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().minorUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().majorUpdateAlertType = <#SirenAlertType_Enum_Value#>
```

## Optional Delegate and Delegate Methods
Six delegate methods allow you to handle or track the user's behavior. Each method has a default, empty implementation, effectively making each of these methods optional.

```	swift
public protocol SirenDelegate: class {
    func sirenDidShowUpdateDialog(alertType: SirenAlertType)   // User presented with update dialog
    func sirenUserDidLaunchAppStore()                          // User did click on button that launched App Store.app
    func sirenUserDidSkipVersion()                             // User did click on button that skips version update
    func sirenUserDidCancel()                                  // User did click on button that cancels update dialog
    func sirenDidFailVersionCheck(error: NSError)              // Siren failed to perform version check (may return system-level error)
    func sirenDidDetectNewVersionWithoutAlert(message: String) // Siren performed version check and did not display alert
}
```

## Localization
Siren is localized for 
- Arabic
- Armenian
- Basque
- Chinese (Simplified and Traditional)
- Danish
- Dutch
- English
- Estonian
- French
- German
- Hebrew
- Hungarian
- Italian
- Japanese
- Korean
- Latvian
- Lithuanian
- Malay
- Polish
- Portuguese (Brazil and Portugal)
- Russian
- Slovenian
- Swedish
- Spanish
- Thai
- Turkish
- Vietnamese

You may want the update dialog to *always* appear in a certain language, ignoring iOS's language setting (e.g. apps released in a specific country).

You can enable it like this:

```swift
Siren.sharedInstance.forceLanguageLocalization = SirenLanguageType.<#SirenLanguageType_Enum_Value#>
```
## Device Compatibility
If an app update is available, Siren checks to make sure that the version of iOS on the user's device is compatible the one that is required by the app update. For example, if a user has iOS 9 installed on their device, but the app update requires iOS 10, an alert will not be shown. This takes care of the *false positive* case regarding app updating.

## Testing Siren
Temporarily change the version string in Xcode (within the `.xcodeproj`) to an older version than the one that's currently available in the App Store. Afterwards, build and run your app, and you should see the alert.

If you currently don't have an app in the store, change your bundleID to one that is already in the store. In the sample app packaged with this library, we use the [iTunes Connect Mobile](https://itunes.apple.com/us/app/itunes-connect/id376771144?mt=8) app's bundleID: `com.apple.itunesconnect.mobile`.

For your convenience, you may turn on debugging statements by setting `self.debugEnabled = true` before calling the `checkVersion()` method.

## App Store Submissions
The App Store reviewer will **not** see the alert. The version in the App Store will always be older than the version being reviewed.

## Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/) & [Aaron Brager](http://twitter.com/getaaron)
