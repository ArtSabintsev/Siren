# Siren

The Siren Class.

``` swift
public final class Siren: NSObject
```

## Inheritance

`NSObject`

## Nested Type Aliases

### `ResultsHandler`

Return results or errors obtained from performing a version check with Siren.

``` swift
public typealias ResultsHandler = (Result<UpdateResults, KnownError>) -> Void
```

## Properties

### `shared`

The Siren singleton. The main point of entry to the Siren library.

``` swift
let shared
```

### `apiManager`

The manager that controls the App Store API that is
used to fetch the latest version of the app.

``` swift
var apiManager: APIManager = .default
```

Defaults to the US App Store.

### `presentationManager`

The manager that controls the update alert's string localization and tint color.

``` swift
var presentationManager: PresentationManager = .default
```

Defaults the string's lange localization to the user's device localization.

### `rulesManager`

The manager that controls the type of alert that should be displayed
and how often an alert should be displayed dpeneding on the type
of update that is available relative to the installed version of the app
(e.g., different rules for major, minor, patch and revision updated can be used).

``` swift
var rulesManager: RulesManager = .default
```

Defaults to performing a version check once a day with an alert that allows
the user to skip updating the app until the next time the app becomes active or
skipping the update all together until another version is released.

## Methods

### `wail(performCheck:completion:)`

This method executes the Siren version checking and alert presentation flow.

``` swift
func wail(performCheck: PerformCheck = .onForeground, completion handler: ResultsHandler? = nil)
```

#### Parameters

  - performCheck: Defines how the version check flow is entered. Defaults to `.onForeground`.
  - handler: Returns the metadata around a successful version check and interaction with the update modal or it returns nil.

### `launchAppStore()`

Launches the AppStore in two situations when the user clicked the `Update` button in the UIAlertController modal.

``` swift
func launchAppStore()
```

This function is marked `public` as a convenience for those developers who decide to build a custom alert modal
instead of using Siren's prebuilt update alert.
