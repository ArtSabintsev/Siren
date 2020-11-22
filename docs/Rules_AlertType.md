# Rules.AlertType

Determines the type of alert to present after a successful version check has been performed.

``` swift
enum AlertType
```

## Enumeration Cases

### `force`

Forces the user to update your app (1 button alert).

``` swift
case force
```

### `option`

Presents the user with option to update app now or at next launch (2 button alert).

``` swift
case option
```

### `skip`

Presents the user with option to update the app now, at next launch, or to skip this version all together (3 button alert).

``` swift
case skip
```

### `none`

Doesn't present the alert.
Use this option if you would like to present a custom alert to the end-user.

``` swift
case none
```
