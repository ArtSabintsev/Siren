# PresentationManager

PresentationManager for Siren

``` swift
public class PresentationManager
```

## Initializers

### `init(alertTintColor:appName:alertTitle:alertMessage:updateButtonTitle:nextTimeButtonTitle:skipButtonTitle:forceLanguageLocalization:)`

`PresentationManager`'s public initializer.

``` swift
public init(alertTintColor tintColor: UIColor? = nil, appName: String? = nil, alertTitle: String = AlertConstants.alertTitle, alertMessage: String = AlertConstants.alertMessage, updateButtonTitle: String = AlertConstants.updateButtonTitle, nextTimeButtonTitle: String = AlertConstants.nextTimeButtonTitle, skipButtonTitle: String = AlertConstants.skipButtonTitle, forceLanguageLocalization forceLanguage: Localization.Language? = nil)
```

#### Parameters

  - tintColor: The alert's tintColor. Settings this to `nil` defaults to the system default color.
  - appName: The name of the app (overrides the default/bundled name).
  - alertTitle: The title field of the `UIAlertController`.
  - alertMessage: The `message` field of the `UIAlertController`.
  - nextTimeButtonTitle: The `title` field of the Next Time Button `UIAlertAction`.
  - skipButtonTitle: The `title` field of the Skip Button `UIAlertAction`.
  - updateButtonTitle: The `title` field of the Update Button `UIAlertAction`.
  - forceLanguage: The language the alert to which the alert should be set. If `nil`, it falls back to the device's preferred locale.

## Properties

### `` `default` ``

The default `PresentationManager`.

``` swift
let `default`
```

By default:

  - There is no tint color (defaults to Apple's system `blue` color.)

  - The name of the app is equal to the name that appears in `Info.plist`.

  - The strings are all set to that of the user's device localization (if supported) or it falls back to English.
