# RulesManager

RulesManager for Siren

``` swift
public struct RulesManager
```

## Initializers

### `init(majorUpdateRules:minorUpdateRules:patchUpdateRules:revisionUpdateRules:showAlertAfterCurrentVersionHasBeenReleasedForDays:)`

Initializer that sets update-specific `Rules` for all updates (e.g., major, minor, patch, revision).
This means that each of the four update types can have their own specific update rules.

``` swift
public init(majorUpdateRules: Rules = .default, minorUpdateRules: Rules = .default, patchUpdateRules: Rules = .default, revisionUpdateRules: Rules = .default, showAlertAfterCurrentVersionHasBeenReleasedForDays releasedForDays: Int = 1)
```

By default, the `releasedForDays` parameter delays the update alert from being presented for *1 day*
to avoid an issue where the *iTunes Lookup* API response is updated faster than the time it takes for the binary
to become available on App Store CDNs across all regions. Usually it takes 6-24 hours, hence the *1 day* delay.

> 

#### Parameters

  - rules: The rules that should be set for all version updates.
  - releasedForDays: The amount of time (in days) that the app should delay before presenting the user

### `init(globalRules:showAlertAfterCurrentVersionHasBeenReleasedForDays:)`

Initializer that sets the same update `Rules` for all types of updates (e.g., major, minor, patch, revision).
This means that all four update types will use the same presentation rules.

``` swift
public init(globalRules rules: Rules = .default, showAlertAfterCurrentVersionHasBeenReleasedForDays releasedForDays: Int = 1)
```

By default, the `releasedForDays` parameter delays the update alert from being presented for *1 day*
to avoid an issue where the *iTunes Lookup* API response is updated faster than the time it takes for the binary
to become available on App Store CDNs across all regions. Usually it takes 6-24 hours, hence the *1 day* delay.

> 

#### Parameters

  - rules: The rules that should be set for all version updates.
  - releasedForDays: The amount of time (in days) that the app should delay before presenting the user

## Properties

### `` `default` ``

The default `RulesManager`.

``` swift
let `default`
```

By default, the `Rules.default` rule is used for all update typs.
