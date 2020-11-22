# APIManager

APIManager for Siren

``` swift
public struct APIManager
```

## Initializers

### `init(country:)`

Initializes `APIManager` to the region or country of an App Store in which the app is available.
By default, all version check requests are performed against the US App Store.

``` swift
public init(country: AppStoreCountry = .unitedStates)
```

#### Parameters

  - country: The country for the App Store in which the app is available.

### `init(countryCode:)`

Convenience initializer that initializes `APIManager` to the region or country of an App Store in which the app is available.
If nil, version check requests are performed against the US App Store.

``` swift
public init(countryCode: String?)
```

#### Parameters

  - countryCode: The raw country code for the App Store in which the app is available.

## Properties

### `` `default` ``

The default `APIManager`.

``` swift
let `default`
```

The version check is performed against the  US App Store.
