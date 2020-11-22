# Types

  - [APIManager](/APIManager):
    APIManager for Siren
  - [PresentationManager](/PresentationManager):
    PresentationManager for Siren
  - [RulesManager](/RulesManager):
    RulesManager for Siren
  - [RulesManager.UpdateType](/RulesManager_UpdateType):
    Informs Siren of the type of update that is available so that
    the appropriate ruleset is used to present the update alert.
  - [AlertAction](/AlertAction):
    The `UIAlertController` button that was pressed upon being presented an update alert.
  - [AlertConstants](/AlertConstants):
    The default constants used for the update alert's messaging.
  - [AppStoreCountry](/AppStoreCountry):
    Region or country of an App Store in which an app can be available.
  - [Localization](/Localization):
    Localization information and strings for Siren.
  - [Localization.Language](/Localization_Language):
    Determines the available languages in which the update message and alert button titles should appear.
  - [Model](/Model):
    The validated and unwrapped `APIModel`.
    This model is presented to the end user in Siren's completion handler.
  - [PerformCheck](/PerformCheck):
    The type of check to perform when Siren's `wail` method is performed.
  - [Rules](/Rules):
    Alert Presentation Rules for Siren.
  - [Rules.AlertType](/Rules_AlertType):
    Determines the type of alert to present after a successful version check has been performed.
  - [Rules.UpdatePromptFrequency](/Rules_UpdatePromptFrequency):
    Determines the frequency in which the user is prompted to update the app
    once a new version is available in the App Store and if they have not updated yet.
  - [UpdateResults](/UpdateResults):
    The relevant metadata returned from Siren upon completing a successful version check.
  - [Siren](/Siren):
    The Siren Class.
  - [KnownError](/KnownError):
    Enumerates all potentials errors that Siren can handle.

# Operators

  - [==(lhs:​rhs:​)](/==\(lhs:rhs:\)):
    Adds ability to equate instances of `AppStoreCountry` to each other.
