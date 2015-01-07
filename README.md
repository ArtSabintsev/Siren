# Siren

### Notify users when a new version of your app is available, and prompt them with the App Store link.

---
### About
**Siren** checks a user's currently installed version of your iOS app against the version that is currently available in the App Store. If a new version is available, an instance of `UIAlertView` (iOS 7) or `UIAlertController` (iOS 8) can be presented to the user informing them of the newer version, and giving them the option to update the application. Alternatively, Siren can notify your app programmatically, so that you can inform the user through a custom UI if you so chose.

- Siren is built to work with the [**Semantic Versioning**](http://semver.org/) system.
- Siren is a Swift language port of [**Harpy**](http://github.com/ArtSabintsev/Harpy), an Objective-C library that achieves the same functionality.
- Siren is actively maintained by [**Arthur Sabintsev**](http://github.com/ArtSabintsev) and [**Aaron Brager**](http://twitter.com/getaaron).

### Changelog
#### 0.1.0
- Initial development launch

### Features
- CocoaPods Support
- Support for `UIAlertController` (iOS 8+) and `UIAlertView` (iOS 7)
- Three types of alerts to present to the user (see **Screenshots** section)
- Optional delegate and delegate methods (see **Optional Delegate** section)
- Localized for 18 languages: Basque, Chinese (Simplified), Chinese (Traditional), Danish, Dutch, English, French, German, Hebrew, Italian, Japanese, Korean, Portuguese, Russian, Slovenian, Swedish, Spanish, and Turkish.
	- Optional ability to override an iOS device's default language to force the localization of your choice 
	- Refer to the **Force Localization** section

### Screenshots & Alert Types

Siren can force an update, let the user optionally update, and allow the user to skip an update.

To control this behavior, assign a `SirenAlertType` to `alertType` (or one of the specific alert type properties).
 
> #### `siren.alertType = .Force`
>
> Forces the user to update.
>
> ![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picForcedUpdate.png?raw=true "Forced Update") 
> ----
> #### `siren.alertType = .Option`
> The default behavior. 
> 
> ![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picOptionalUpdate.png?raw=true "Optional Update")
> ----
> #### `siren.alertType = .Skip`
> Allows the user to opt out of future reminders for this version.
>
> ![Skip Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picSkippedUpdate.png?raw=true "Optional Update")
> ----
> #### `SirenAlertType.None`
>
> This option doesn't show an alert view. It's useful for skipping Patch, Minor, or Major updates.
>
> **Note:** If you don't want to show *any* alert views, see *Prompting for Updates Without Alert Views* below.

### Prompting for Updates without using Alerts

To use less obtrusive update indicators, like a badge, banner, or small icon, disable alert presentation. To accomplish this, set `shouldShowAlert` to `false` when you call `checkVersion(checkType: SirenVersionCheckType, shouldShowAlert: Bool)`. Siren will call the `sirenDidDetectNewVersionWithoutAlert(message: String)` delegate method, passing a localized, suggested update string suitable for display. Implement this method to display your own messaging, optionally using `message`.

> **Note:** This delegate method will not be called when setting an alert type to `SirenAlertType.None`.

### Installation Instructions

#### CocoaPods Installation
```
pod 'Siren'
```

#### Manual Installation

Copy the `Siren.swift` file into your project.

### Setup Instructions	

Here's some commented sample code. Adapt this to meet your app's needs.

```Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool 
{
	/* Siren code should go below window?.makeKeyAndVisible() */
	
	// Siren is a singleton
	let siren = Siren.SharedInstance()
	
	// Required: Your app's iTunes App Store ID
	siren.appID = <#Your_App_ID#>
	
	// Required on iOS 8: The controller to present the alert from (usually the UIWindow's rootViewController)
	siren.presentingViewController = window?.rootViewController
	
	// Optional: Defaults to .Option
	siren.alertType = <#SirenAlertType_Enum_Value#>
	
	/*
	    Replace .Immediately with .Daily or .Weekly to specify a maximum daily or weekly frequency for version
	    checks.
	    
       Change shouldShowAlert to false if you're displaying your own UI when Siren detects a new version.
	*/
    siren.checkVersion(.Immediately, shouldShowAlert: true)
}

func applicationDidBecomeActive(application: UIApplication) {
	/*
	    Perform daily (.Daily) or weekly (.Weekly) check for new version of your app. 
	    Useful if user returns to your app from the background after extended period of time.
    	 Place in applicationDidBecomeActive(_:).	*/
    Siren.sharedInstance.checkVersion(.Daily, shouldShowAlert: true)
}

func applicationWillEnterForeground(application: UIApplication) {
   /*
	    Useful if user returns to your app from the background after being sent to the
	    App Store, but doesn't update their app before coming back to your app.
	    
       ONLY USE WITH SirenAlertType.Force
   */

    Siren.sharedInstance.checkVersion(.Immediately, shouldShowAlert: true)
}
```

And you're all set!

### Differentiated Alerts for Patch, Minor, and Major Updates
If you would like to set a different type of alert for patch, minor, and/or major updates, simply add one or all of the following *optional* lines to your setup *before* calling the `checkVersion()` method:

```swift
	/* Siren defaults to SirenAlertType.Option for all updates */
	siren.sharedInstance().patchUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().minorUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().majorUpdateAlertType = <#SirenAlertType_Enum_Value#>
```

### Optional Delegate and Delegate Methods
Five delegate methods allow you to handle or track the user's behavior:

```	swift
@objc protocol SirenDelegate {
    optional func sirenDidShowUpdateDialog()        // User presented with update dialog
    optional func sirenUserDidLaunchAppStore()      // User did click on button that launched App Store.app
    optional func sirenUserDidSkipVersion()         // User did click on button that skips version update
    optional func sirenUserDidCancel()              // User did click on button that cancels update dialog
    
    // Siren performed version check and did not display alert
    optional func sirenDidDetectNewVersionWithoutAlert(message: String)
}
```

### Force Localization
You may want the update dialog to *always* appear in a certain language, ignoring iOS's language setting (e.g. apps released in a specific country).

You can enable it like this:

```swift
Siren.sharedInstance.forceLanguageLocalization = SirenLanguageType.<#SirenLanguageType_Enum_Value#>
```

### App Store Submissions
The App Store reviewer will **not** see the alert. (The version in the App Store will always be older than the version being reviewed.)

### Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/) & [Aaron Brager](http://twitter.com/getaaron)
