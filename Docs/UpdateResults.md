# UpdateResults

The relevant metadata returned from Siren upon completing a successful version check.

``` swift
public struct UpdateResults
```

## Properties

### `alertAction`

The `UIAlertAction` the user chose upon being presented with the update alert.
Defaults to `unknown` until an alert is actually presented.

``` swift
var alertAction: AlertAction = .unknown
```

### `localization`

The Siren-supported locale that was used for the string in the update alert.

``` swift
let localization: Localization
```

### `model`

The Swift-mapped and unwrapped API model, if a successful version check was performed.

``` swift
let model: Model
```

### `updateType`

The type of update that was returned for the API.

``` swift
var updateType: RulesManager.UpdateType = .unknown
```
