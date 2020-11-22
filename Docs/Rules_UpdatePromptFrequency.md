# Rules.UpdatePromptFrequency

Determines the frequency in which the user is prompted to update the app
once a new version is available in the App Store and if they have not updated yet.

``` swift
enum UpdatePromptFrequency
```

## Inheritance

`UInt`

## Enumeration Cases

### `immediately`

Version check performed every time the app is launched.

``` swift
case immediately
```

### `daily`

Version check performed once a day.

``` swift
case daily
```

### `weekly`

Version check performed once a week.

``` swift
case weekly
```
