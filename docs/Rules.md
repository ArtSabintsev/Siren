# Rules

Alert Presentation Rules for Siren.

``` swift
public struct Rules
```

## Initializers

### `init(promptFrequency:forAlertType:)`

Initializes the alert presentation rules.

``` swift
public init(promptFrequency frequency: UpdatePromptFrequency, forAlertType alertType: AlertType)
```

#### Parameters

  - frequency: How often a user should be prompted to update the app once a new version is available in the App Store.
  - alertType: The type of alert that should be presented.

## Properties

### `annoying`

Performs a version check immediately, but allows the user to skip updating the app until the next time the app becomes active.

``` swift
var annoying: Rules
```

### `critical`

Performs a version check immediately and forces the user to update the app.

``` swift
var critical: Rules
```

### `` `default` ``

Performs a version check once a day, but allows the user to skip updating the app until
the next time the app becomes active or skipping the update all together until another version is released.

``` swift
var `default`: Rules
```

This is the default setting.

### `hinting`

Performs a version check weekly, but allows the user to skip updating the app until the next time the app becomes active.

``` swift
var hinting: Rules
```

### `persistent`

Performs a version check daily, but allows the user to skip updating the app until the next time the app becomes active.

``` swift
var persistent: Rules
```

### `relaxed`

Performs a version check weekly, but allows the user to skip updating the app until
the next time the app becomes active or skipping the update all together until another version is released.

``` swift
var relaxed: Rules
```
