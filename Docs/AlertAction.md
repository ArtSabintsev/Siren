# AlertAction

The `UIAlertController` button that was pressed upon being presented an update alert.

``` swift
public enum AlertAction
```

## Enumeration Cases

### `appStore`

The user clicked on the `Update` option, which took them to the app's App Store page.

``` swift
case appStore
```

### `nextTime`

The user clicked on the `Next Time` option, which dismissed the alert.

``` swift
case nextTime
```

### `skip`

The user clicked on the `Skip this version` option, which dismissed the alert.

``` swift
case skip
```

### `unknown`

(Default) The user never chose an option. This is returned when an error is thrown by Siren.

``` swift
case unknown
```
