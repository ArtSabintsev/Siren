# Siren [English](README.md)

### 当您的 app 有新版本可用时提示用户进行更新。

![Travis-CI](https://travis-ci.org/ArtSabintsev/Siren.svg?branch=master) [![CocoaPods](https://img.shields.io/cocoapods/v/Siren.svg)]()  [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)]() [![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/dt/Siren.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/dm/Siren.svg)]()
---

## 关于
**Siren** 用于检测用户当前安装版本是否是 App Store 上的最新可用版本。

当有新版本可用时，Siren 会弹出提示框，用户可根据提示框提供的选项进行更新。或者您也可以根据 Siren 发出的消息来自定义通知用户的方式，比如您可以提供一个自定义的提示框。

## Ports

## 特点
- [x] 支持 Cocoapods
- [x] 支持 Carthage
- [x] 支持 Swift 包管理器
- [x] 30+ 语言本地化 (查看**本地化**)
- [x] 
- [x] 三种类型的弹出提示框 (查看**截图**)
- [x] 可选代理方法 (查看**可选代理**)
- [x] 单元测试！

## 截图

- The **left picture** forces the user to update the app.
- The **center picture** gives the user the option to update the app.
- The **right picture** gives the user the option to skip the current update.
- These options are controlled by the `SirenAlertType` enum.

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

您可以使用条幅或者小图等更友好的方式进行提示。首先，您需要通过下面代码禁用弹出提示框：

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

## 兼容性

## 测试



##创建维护人员
[Arthur Ariel Sabintsev](http://www.sabintsev.com/) & [Aaron Brager](http://twitter.com/getaaron)