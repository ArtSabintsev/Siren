# Localization

Localization information and strings for Siren.

``` swift
public struct Localization
```

## Methods

### `alertMessage(forCurrentAppStoreVersion:)`

The localized string for the `UIAlertController`'s message field.  .

``` swift
public func alertMessage(forCurrentAppStoreVersion currentAppStoreVersion: String) -> String
```

#### Returns

A localized string for the update message.

### `alertTitle()`

The localized string for the `UIAlertController`'s title field.  .

``` swift
public func alertTitle() -> String
```

#### Returns

A localized string for the phrase "Update Available".

### `nextTimeButtonTitle()`

The localized string for the "Next time" `UIAlertAction`.

``` swift
public func nextTimeButtonTitle() -> String
```

#### Returns

A localized string for the phrase "Next time".

### `skipButtonTitle()`

The localized string for the "Skip this version" `UIAlertAction`.

``` swift
public func skipButtonTitle() -> String
```

#### Returns

A localized string for the phrase "Skip this version".

### `updateButtonTitle()`

The localized string for the "Update" `UIAlertAction`.

``` swift
public func updateButtonTitle() -> String
```

#### Returns

A localized string for the phrase "Update".
