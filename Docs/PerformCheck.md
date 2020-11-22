# PerformCheck

The type of check to perform when Siren's `wail` method is performed.

``` swift
public enum PerformCheck
```

> 

## Enumeration Cases

### `onDemand`

Performs a version check only when Siren's `wail` method is called,
as the `UIApplication.didBecomeActiveNotification` is ignored.

``` swift
case onDemand
```

### `onForeground`

(DEFAULT) Perform a version check whenever the app enters the foreground.
This value must be set when Siren's `wail` method is called to enable the
`UIApplication.didBecomeActiveNotification` observer.

``` swift
case onForeground
```
