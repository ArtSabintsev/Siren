# KnownError

Enumerates all potentials errors that Siren can handle.

``` swift
public enum KnownError
```

## Inheritance

`LocalizedError`

## Enumeration Cases

### `appStoreAppIDFailure`

Error retrieving trackId as the JSON does not contain a 'trackId' key.

``` swift
case appStoreAppIDFailure
```

### `appStoreDataRetrievalEmptyResults`

Error retrieving App Store data as JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error.

``` swift
case appStoreDataRetrievalEmptyResults
```

### `appStoreDataRetrievalFailure`

Error retrieving App Store data as an error was returned.

``` swift
case appStoreDataRetrievalFailure(underlyingError: Error?)
```

### `appStoreJSONParsingFailure`

Error parsing App Store JSON data.

``` swift
case appStoreJSONParsingFailure(underlyingError: Error)
```

### `appStoreOSVersionUnsupported`

The version of iOS on the device is lower than that of the one required by the app version update.

``` swift
case appStoreOSVersionUnsupported
```

### `appStoreVersionArrayFailure`

Error retrieving App Store verson number as the JSON does not contain a `version` key.

``` swift
case appStoreVersionArrayFailure
```

### `currentVersionReleaseDate`

The `currentVersionReleaseDate` key is missing in the JSON payload. Please leave an issue on https:​//github.com/ArtSabintsev/Siren with as many details as possible.

``` swift
case currentVersionReleaseDate
```

### `malformedURL`

One of the iTunes URLs used in Siren is malformed. Please leave an issue on https:​//github.com/ArtSabintsev/Siren with as many details as possible.

``` swift
case malformedURL
```

### `missingBundleID`

Please make sure that you have set a `Bundle Identifier` in your project.

``` swift
case missingBundleID
```

### `noUpdateAvailable`

No new update available.

``` swift
case noUpdateAvailable
```

### `recentlyPrompted`

Siren will not present an update alert if it performed one too recently. If you would like to present an alert every time Siren is called, please consider setting the `UpdatePromptFrequency.immediately` rule in `RulesManager`

``` swift
case recentlyPrompted
```

### `releasedTooSoon`

The app has been released for X days, but Siren cannot prompt the user until Y (where Y \> X) days have passed.

``` swift
case releasedTooSoon(daysSinceRelease: Int, releasedForDays: Int)
```

### `skipVersionUpdate`

The user has opted to skip updating their current version of the app to the current App Store version.

``` swift
case skipVersionUpdate(installedVersion: String, appStoreVersion: String)
```

## Properties

### `localizedDescription`

The localized description for each error handled by Siren.

``` swift
var localizedDescription: String
```
