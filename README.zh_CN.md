# Siren [English](README.md)

### 当您的 app 有新版本可用时提示用户进行更新。

![Travis-CI](https://travis-ci.org/ArtSabintsev/Siren.svg?branch=master) [![CocoaPods](https://img.shields.io/cocoapods/v/Siren.svg)]()  [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)]() [![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/dt/Siren.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/dm/Siren.svg)]()
---

## 关于
**Siren** 用于检测用户当前安装版本是否是 App Store 上的最新可用版本。

当 app 有更新时，Siren 会弹出提示框，用户可根据提示框提供的选项进行更新。或者您也可以根据 Siren 发出的消息来自定义通知用户的方式，比如您可以提供一个自定义的提示框。

- Siren 可配合 [**Semantic Versioning**](http://semver.org/) 系统使用
	- Semantic 版本系统由三位数字标识 (比如，1.0.0)
	- Siren 同时支持两位数字标识 (比如，1.0)
	- Siren 同时支持四位数字标识 (比如，1.0.0.0)
- Siren 当前处于活跃维护状态，由[**Arthur Sabintsev**](http://github.com/ArtSabintsev) 和 [**Aaron Brager**](http://twitter.com/getaaron) 进行维护。


## Ports
- [**Harpy**](http://github.com/ArtSabintsev/Harpy) 是 Objective-C 实现的版本更新检查库，Siren 是 Harpy 的 swift 版本。
- Siren 和 Harpy 是由相同的开发者维护。
- 安卓平台 Play Store 上的 [**Egghead Games' Siren library**](https://github.com/eggheadgames/Siren) 库使用了和 Siren 相同的原理实现了版本更新检测。
- 针对 React Native 项目 (iOS/Android) 的 [**Gant Laborde's Siren library**](https://github.com/GantMan/react-native-siren) 库使用了和 Siren 相同的原理实现了版本更新检测。

## 特点
- [x] 支持 Cocoapods
- [x] 支持 Carthage
- [x] 支持 Swift 包管理器
- [x] 30+ 语言本地化 (查看**本地化**)
- [x] 设备兼容性检测 (查看**设备兼容性**)
- [x] 三种类型的弹出提示框 (查看**截图**)
- [x] 可选代理方法 (查看**可选代理**)
- [x] 单元测试！

## 截图

- **左图** 强制用户更新
- **中间** 给用户提供更新选项
- **右图** 给用户提供更新和跳过更新选项
- 这些选项对应着 `SirenAlertType` 枚举类型

<img src="https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picForcedUpdate.png?raw=true" height=480">
<img src="https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picOptionalUpdate.png?raw=true" height=480">
<img src="https://github.com/ArtSabintsev/Harpy/blob/master/samplePictures/picSkippedUpdate.png?raw=true" height=480">

## 安装指南

### CocoaPods
Swift 3 版本：
```ruby
pod 'Siren'
```

Swift 2.3 版本:

```ruby
pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift2.3'
```

Swift 2.2 版本:

```ruby
pod 'Siren', '0.9.5'
```

### Carthage
FSwift 3 版本:

``` swift
github "ArtSabintsev/Siren"
```

Swift 2.3 版本:

``` swift
github "ArtSabintsev/Siren" "swift2.3"
```

### Swift 包管理器
```swift
.Package(url: "https://github.com/ArtSabintsev/Siren.git", majorVersion: 1)
```

## 使用
下面是一些示例代码。请根据您的需求进行修改。更详细的使用说明请参考示例项目中的 https://github.com/ArtSabintsev/Siren/blob/master/Sample%20App/Sample%20App/AppDelegate.swift。

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
    siren.checkVersion(checkType: .immediately)

    return true
}

func applicationDidBecomeActive(application: UIApplication) {
	/*
	    Perform daily (.Daily) or weekly (.Weekly) checks for new version of your app.
	    Useful if user returns to your app from the background after extended period of time.
    	 Place in applicationDidBecomeActive(_:).	*/

    Siren.sharedInstance.checkVersion(checkType: .daily)
}

func applicationWillEnterForeground(application: UIApplication) {
   /*
	    Useful if user returns to your app from the background after being sent to the
	    App Store, but doesn't update their app before coming back to your app.

       ONLY USE WITH SirenAlertType.Force
   */

    Siren.sharedInstance.checkVersion(checkType: .immediately)
}
```

### 使用非弹出提示框进行提示

您可以使用顶部条幅等更友好的方式进行提示。首先，您需要通过下面代码禁用弹出提示框：

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	...
	siren.delegate = self
	siren.alertType = .None
	...
}

extension AppDelegate: SirenDelegate {
	// 当检测到有更新可用时向该代理方法传递一个本地化的提示信息
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print("\(message)")
    }
}
```
Siren 会调用 `sirenDidDetectNewVersionWithoutAlert(message: String)` 代理方法，该方法传递了一个本地化的更新提示信息作为参数。您可以使用该参数作为提示信息，也可以使用自定义的提示信息。

## 为修订版，补丁，小版本，大版本设置不同的提示框类型
您可以为修订版，补丁，小版本，大版本等设置不同提示框类型，只需要在 `checkVersion()` 方法前调用进行如下设置即可：

```swift
	/* Siren defaults to SirenAlertType.Option for all updates */
	siren.sharedInstance().revisionUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().patchUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().minorUpdateAlertType = <#SirenAlertType_Enum_Value#>
	siren.sharedInstance().majorUpdateAlertType = <#SirenAlertType_Enum_Value#>
```

##可选代理和代理方法
您可以通过下面六个代理方法跟踪用户进行的操作。

```	swift
public protocol SirenDelegate: class {
    func sirenDidShowUpdateDialog(alertType: SirenAlertType)   // 弹出更新提示框
    func sirenUserDidLaunchAppStore()                          // 用户点击去 app store 更新
    func sirenUserDidSkipVersion()                             // 用户点击跳过此次更新
    func sirenUserDidCancel()                                  // 用户点击取消更新
    func sirenDidFailVersionCheck(error: NSError)              // 检查更新失败(可能返回系统级别的错误)
    func sirenDidDetectNewVersionWithoutAlert(message: String) // 检测到更新但不弹出提示框
}
```

## 本地化
Siren 为以下国家做了本地化
- Arabic
- Armenian
- Basque
- Chinese (Simplified and Traditional)
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
- Polish
- Portuguese (Brazil and Portugal)
- Russian
- Serbian (Cyrillic and Latin)
- Slovenian
- Swedish
- Spanish
- Thai
- Turkish
- Vietnamese

您可以通过以下代码忽略 iOS 系统语言设置，为弹出框设置固定语言。

```swift
Siren.sharedInstance.forceLanguageLocalization = SirenLanguageType.<#SirenLanguageType_Enum_Value#>
```

## 设备兼容性
当有更新可用时，Siren 会检测用户的 iOS 版本号是否符合更新需求。比如，用户的系统是 iOS 9，但此次更新只针对 iOS 10，这时是不会出现弹出提示框。

## 测试
测试时，需要暂时将 Xcode 里(`.xcodeproj` 文件) 的版本号修改为比当前苹果商店中的可用版本号大。这样编译运行 app 时，您就可以看到弹出提示框。

如果您尚未发布过 App，把 bundleID 修改为一个 app store 已经存在的 bundleID。在示例项目中，我们使用了 [iTunes Connect Mobile](https://itunes.apple.com/us/app/itunes-connect/id376771144?mt=8) 的 bundleID：`com.apple.itunesconnect.mobile`。

为方便调试，您可以在调用 `checkVersion()` 方法前通过 `self.debugEnabled = true` 来开启调试模式。

## 提交至 App Store
因为商店里的可用版本总是比提交审核的版本老，所以苹果商店审核人员在审核时是**不会**弹出提示框的。

##创建维护人员
[Arthur Ariel Sabintsev](http://www.sabintsev.com/) & [Aaron Brager](http://twitter.com/getaaron)

## 翻译人员
[Daniel Hu](http://www.jianshu.com/u/d8bbc4831623)