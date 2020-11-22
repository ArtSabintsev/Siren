# Model

The validated and unwrapped `APIModel`.
This model is presented to the end user in Siren's completion handler.

``` swift
public struct Model
```

## Properties

### `appID`

The app's App ID.

``` swift
let appID: Int
```

### `currentVersionReleaseDate`

The release date for the latest version of the app.

``` swift
let currentVersionReleaseDate: String
```

### `minimumOSVersion`

The minimum version of iOS that the current version of the app requires.

``` swift
let minimumOSVersion: String
```

### `releaseNotes`

The releases notes from the latest version of the app.

``` swift
let releaseNotes: String?
```

### `version`

The latest version of the app.

``` swift
let version: String
```
