# Siren 🚨

### Notify users when a new version of your app is available and prompt them to upgrade.

[![Travis CI Status](https://travis-ci.org/ArtSabintsev/Siren.svg?branch=master)](https://travis-ci.org/ArtSabintsev/Siren) ![Swift Support](https://img.shields.io/badge/Swift-5.5-orange.svg) [![CocoaPods](https://img.shields.io/cocoapods/v/Siren.svg)](https://cocoapods.org/pods/Siren) [![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/) [![Accio supported](https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat)](https://github.com/JamitLabs/Accio) 

---

# Table of Contents
- [**Meta**](https://github.com/ArtSabintsev/Siren#meta)
	- [About](https://github.com/ArtSabintsev/Siren#about)
	- [Features](https://github.com/ArtSabintsev/Siren#features)
	- [Screenshots](https://github.com/ArtSabintsev/Siren#screenshots)
 	- [Ports](https://github.com/ArtSabintsev/Siren#ports)
- [**Installation and Integration**](https://github.com/ArtSabintsev/Siren#installation-and-integration)
	- [Installation Instructions](https://github.com/ArtSabintsev/Siren#installation-instructions)
	- [Implementation Examples](https://github.com/ArtSabintsev/Siren#implementation-examples)
- [**Device-Specific Checks**](https://github.com/ArtSabintsev/Siren#device-specific-checks)
	- [Localization](https://github.com/ArtSabintsev/Siren#localization)
	- [Device Compatibility](https://github.com/ArtSabintsev/Siren#device-compatibility)
- [**Testing**](https://github.com/ArtSabintsev/Siren#testing)
	- [Testing Siren Locally](https://github.com/ArtSabintsev/Siren#testing-siren-locally)
	- [Words of Caution](https://github.com/ArtSabintsev/Siren#words-of-caution)
- [**App Submission**](https://github.com/ArtSabintsev/Siren#app-submission)
	- [App Store Review](https://github.com/ArtSabintsev/Siren#app-store-review)
	- [Phased Releases](https://github.com/ArtSabintsev/Siren#phased-releases)
- [**Attribution**](https://github.com/ArtSabintsev/Siren#attribution)
	- [Special Thanks](https://github.com/ArtSabintsev/Siren#special-thanks)
	- [Creator](https://github.com/ArtSabintsev/Siren#creator)

---

# Meta

## About
**Siren** checks a user's currently installed version of your iOS app against the version that is currently available in the App Store.

If a new version is available, a language localized alert can be presented to the user informing them of the newer version, and giving them the option to update the application. Alternatively, Siren can notify your app through alternative means, such as a custom user interface.

Siren is built to work with the [**Semantic Versioning**](https://semver.org/) system.
  - Canonical Semantic Versioning uses a three number versioning system (e.g., 1.0.0)
  - Siren also supports two-number versioning (e.g., 1.0) and four-number versioning (e.g., 1.0.0.0)

## Features

### Current Features
- [x] Compatible with iOS 13+ and tvOS 13+
- [x] CocoaPods and Swift Package Manager Support (see [Installation Instructions](https://github.com/ArtSabintsev/Siren#installation-instructions))
- [x] Three Types of Alerts (see [Screenshots](https://github.com/ArtSabintsev/Siren#screenshots))
- [x] Highly Customizable Presentation Rules (see [Implementation Examples](https://github.com/ArtSabintsev/Siren#implementation-examples))
- [x] Localized for 40+ Languages (see [Localization](https://github.com/ArtSabintsev/Siren#localization))
- [x] Device Compatibility Check (see [Device Compatibility](https://github.com/ArtSabintsev/Siren#device-compatibility))

---

## Screenshots
- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `Rules.AlertType` enum.

<img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picForcedUpdate.png?raw=true" height="480"><img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picOptionalUpdate.png?raw=true" height="480"><img src="https://github.com/ArtSabintsev/Siren/blob/master/Assets/picSkippedUpdate.png?raw=true" height="480">

## Ports
- **Objective-C (iOS)**
   - [**Harpy**](https://github.com/ArtSabintsev/Harpy)
   - Siren was ported _from_ Harpy, as Siren and Harpy are maintained by the same developer.
   - As of December 2018, Harpy has been deprecated in favor of Siren.
- **Java (Android)**
   - [**Egghead Games' Siren library**](https://github.com/eggheadgames/Siren)
   - The Siren Swift library inspired the Java library.
- **React Native (iOS)**
   - [**Gant Laborde's Siren library**](https://github.com/GantMan/react-native-siren)
   - The Siren Swift library inspired the React Native library.

---

# Installation and Integration

## Installation Instructions

| Swift Version |  Branch Name  | Will Continue to Receive Updates?
| ------------- | ------------- |  -------------
| 5.5+ | master | **Yes**
| 5.1-5.4 | swift5.4 | No
| 5.0 | swift5.0 | No
| 4.2 | swift4.2 | No
| 4.1 | swift4.1 | No
| 3.2 | swift3.2 | No
| 3.1 | swift3.1 | No
| 2.3 | swift2.3 | No  

### CocoaPods
```ruby
pod 'Siren' # Swift 5.5+
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift5.4' # Swift 5.1-5.4
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift5.0' # Swift 5.0
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift4.2' # Swift 4.2
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift4.1' # Swift 4.1
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift3.2' # Swift 3.2
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift3.1' # Swift 3.1
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift2.3' # Swift 2.3
```

### Swift Package Manager
```swift
.Package(url: "https://github.com/ArtSabintsev/Siren.git", majorVersion: 6)
```

## Implementation Examples
Implementing Siren is as easy as adding two lines of code to your app in **either** `AppDelegate.swift` or `SceneDelegate.swift`:

### AppDelegate.swift Example
```swift
import Siren // Line 1
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()

	Siren.shared.wail() // Line 2

        return true
    }
}
```

### SceneDelegate.swift Example
```swift
import Siren // Line 1
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.makeKeyAndVisible()

	Siren.shared.wail() // Line 2

        return true
    }
}
```

Siren also has plenty of customization options. All examples can be found in the Example Project's [**AppDelegate**](https://github.com/ArtSabintsev/Siren/blob/master/Example/Example/AppDelegate.swift) file. Uncomment the example you'd like to test.

---

# Device-Specific Checks

## Localization
Siren is localized for the following languages:

Arabic, Armenian, Basque, Chinese (Simplified and Traditional), Croatian, Czech, Danish, Dutch, English, Estonian, Finnish, French, German, Greek, Hebrew, Hungarian, Indonesian, Italian, Japanese, Korean, Latvian, Lithuanian, Malay, Norwegian (Bokmål), Persian (Afghanistan, Iran, Persian), Polish, Portuguese (Brazil and Portugal), Romanian, Russian, Serbian (Cyrillic and Latin), Slovenian, Spanish, Swedish, Thai, Turkish, Ukrainian, Urdu, Vietnamese

If your user's device is set to one of the supported locales, an update message will appear in that language. If a locale is not supported, than the message will appear in English.

You may want the update dialog to *always* appear in a certain language, ignoring the user's device-specific setting. You can enable it like so:

```swift
// In this example, we force the `Russian` language.
Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .russian)
```

## Device Compatibility
If an app update is available, Siren checks to make sure that the version of iOS on the user's device is compatible with the one that is required by the app update. For example, if a user has iOS 11 installed on their device, but the app update requires iOS 12, an alert will not be shown. This takes care of the *false positive* case regarding app updating.

---

# Testing

## Testing Siren Locally
Temporarily change the version string in Xcode (within the `.xcodeproj` file) to an older version than the one that's currently available in the App Store. Afterwards, build and run your app, and you should see the alert.

If you currently don't have an app in the store, change your bundleID to one that is already in the store. In the sample app packaged with this library, we use Facebook's Bundle ID: `com.facebook.Facebook`.

## Words of Caution
Occasionally, the iTunes JSON will update faster than the App Store CDN, meaning the JSON may state that the new version of the app has been released, while no new binary is made available for download via the App Store. It is for this reason that Siren will, by default, wait 1 day (24 hours) after the JSON has been updated to prompt the user to update. To change the default setting, please modify the value of `showAlertAfterCurrentVersionHasBeenReleasedForDays`.

---

# App Submission

## App Store Review
The App Store reviewer will **not** see the alert. The version in the App Store will always be older than the version being reviewed.

## Phased Releases
In 2017, Apple announced the [ability to rollout app updates gradually (a.k.a. Phased Releases)](https://itunespartner.apple.com/en/apps/faq/Managing%20Your%20Apps_Submission%20Process). Siren will continue to work as it has in the past, presenting an update modal to _all_ users. If you opt-in to a phased rollout for a specific version, you have a few choices:

- You can leave Siren configured as normal. Phased rollout will continue to auto-update apps. Since all users can still manually update your app directly from the App Store, Siren will ignore the phased rollout and will prompt users to update.
- You can set `showAlertAfterCurrentVersionHasBeenReleasedForDays` to `7`, and Siren will not prompt any users until the latest version is 7 days old, after the phased rollout is complete.
- You can remotely disable Siren until the rollout is done using your own API / backend logic.

---

# Attribution 

## Special Thanks
A massive shout-out and thank you goes to the following folks: 

- [Aaron Brager](https://twitter.com/@getaaron) for motivating me and assisting me in building the initial proof-of-concept of Siren (based on [Harpy](https:github.com/ArtSabintsev/Harpy)) back in 2015. Without him, Siren may never have been built. 
- All of [Harpy's Contributors](https://github.com/ArtSabintsev/Harpy/graphs/contributors) for helping building the feature set from 2012-2015 that was used as the basis for the first version of Siren.
- All of [Siren's Contributors](https://github.com/ArtSabintsev/Siren/graphs/contributors) for helping make Siren as powerful and bug-free as it currently is today.

## Creator
[Arthur Ariel Sabintsev](http://www.sabintsev.com/)
