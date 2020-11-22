# RulesManager.UpdateType

Informs Siren of the type of update that is available so that
the appropriate ruleset is used to present the update alert.

``` swift
public enum UpdateType
```

  - major: Major release available: A.b.c.d

  - minor: Minor release available: a.B.c.d

  - patch: Patch release available: a.b.C.d

  - revision: Revision release available: a.b.c.D

  - unknown: No information available about the update.

## Inheritance

`String`

## Enumeration Cases

### `major`

Major release available:​ A.b.c.d

``` swift
case major
```

### `minor`

Minor release available:​ a.B.c.d

``` swift
case minor
```

### `patch`

Patch release available:​ a.b.C.d

``` swift
case patch
```

### `revision`

Revision release available:​ a.b.c.D

``` swift
case revision
```

### `unknown`

No information available about the update.

``` swift
case unknown
```
