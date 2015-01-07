# Siren
### Notify users when a new version of your app is available, and prompt them with the App Store link.

---
### About
**Siren** is a utility that checks a user's currently installed version of your iOS application against the version that is currently available in the App Store. If a new version is available, an instance of UIAlertView (iOS 6, 7) or UIAlertController (iOS 8) is presented to the user informing them of the newer version, and giving them the option to update the application. 

- Siren is built to work with the [**Semantic Versioning**](http://semver.org/) system.
- Siren is a Swift port of [**Harpy**](http://github.com/ArtSabintsev/Harpy), an Objective-C library that achieves the same functionality.
- Siren is actively maintained by [**Arthur Sabintsev**](http://github.com/ArtSabintsev) and [**Aaron Brager**](http://github.com/GetAaron).

### Changelog
#### 1.0.0
- Initial launch

### Features
- Cocoapods Support
- Support for UIAlertController (iOS 8+) and UIAlertView (Older versions of iOS)
- Three types of alerts to present to the end-user (see **Screenshots** section)
- Optional delegate and delegate methods (see **Optional Delegate** section)
- Localized for 18 languages: Basque, Chinese (Simplified), Chinese (Traditional), Danish, Dutch, English, French, German, Hebrew, Italian, Japanese, Korean, Portuguese, Russian, Slovenian, Swedish, Spanish, and Turkish.
	- Optional ability to override an iOS device's default language to force the localization of your choice 
	- Refer to the **Force Localization** section

### Screenshots

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `HarpyAlertType` typede that is found in `Harpy.h`.
 
![Forced Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picForcedUpdate.png?raw=true "Forced Update") 
![Optional Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picOptionalUpdate.png?raw=true "Optional Update")
![Skipped Update](https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picSkippedUpdate.png?raw=true "Optional Update")

### Installation Instructions

#### CocoaPods Installation
```
pod 'Siren'
```

#### Manual Installation

Copy the `Siren.swift` file into your project.

### Setup Instructions	
~~~ Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool 
{
	/* Siren code should go below window?.makeKeyAndVisible() */
	
	// Siren is a singleton
	let siren = Siren.SharedInstance()
	
	// Required: Your apps iTunes App Store ID
	siren.appID = <#Your_App_ID#>
	
	// Required: The UIWindow's rootViewController
	siren.presentingViewController = window?.rootViewController
	
	/* 
		Optional:
		Defaults to .Option
	*/ 
	siren.alertType = <#SirenAlertType_Enum_Value#>
	
	/*
	*/
	siren.checkVersion(<#
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	 
	/*
	 Perform daily check for new version of your app
	 Useful if user returns to you app from background after extended period of time
 	 Place in applicationDidBecomeActive:
 	 
 	 Also, performs version check on first launch.
 	*/
	[[Harpy sharedInstance] checkVersionDaily];

	/*
	 Perform weekly check for new version of your app
	 Useful if you user returns to your app from background after extended period of time
	 Place in applicationDidBecomeActive:
	 
	 Also, performs version check on first launch.
	 */
	[[Harpy sharedInstance] checkVersionWeekly];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Perform check for new version of your app
	 Useful if user returns to you app from background after being sent tot he App Store, 
	 but doesn't update their app before coming back to your app.
 	 
 	 ONLY USE THIS IF YOU ARE USING *HarpyAlertTypeForce* 
 	 
 	 Also, performs version check on first launch.
 	*/
	[[Harpy sharedInstance] checkVersion];    
}

~~~

And you're all set!

### Differentiated Alerts for Patch, Minor, and Major Updates
If you would like to set a different type of alert for patch, minor, and/or major updates, simply add one or all of the following *optional* lines to your setup *before* calling the `checkVersion()` method:

~~~ swift-c
	/* By default, Siren is configured to use SirentAlertType.Option for all version updates */
	siren.sharedInstance().patchUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().minorUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().majorUpdateAlertType = <#SirenAlertType_Enum_Value#>
~~~

### Optional Delegate and Delegate Methods
If you'd like to handle or track the end-user's behavior, four delegate methods have been made available to you:

```	obj-c
	// User presented with update dialog
	- (void)harpyDidShowUpdateDialog;
	
	// User did click on button that launched App Store.app
	- (void)harpyUserDidLaunchAppStore;
	
	// User did click on button that skips version update
	- (void)harpyUserDidSkipVersion;
	
	// User did click on button that cancels update dialog
	- (void)harpyUserDidCancel;
```

### Force Localization
There are some situations where a developer may want to the update dialog to *always* appear in a certain language, irrespective of the devices/system default language (e.g. apps released in a specific country). As of v2.5.0, this feature has been added to Harpy (see [Issue #41](https://github.com/ArtSabintsev/Harpy/issues/41)). Please set the `forceLanguageLocalization` property using the `HarpyLanugage` string constants defined in `Harpy.h` if you would like override the system's default lanuage for the Harpy alert dialogs.

``` obj-c 
[[Harpy sharedInstance] setForceLanguageLocalization<#HarpyLanguageConstant#>];
```

### Important Note on App Store Submissions
The App Store reviewer will **not** see the alert. 

### Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/) & [Aaron Brager](http://github.com/GetAaron)
