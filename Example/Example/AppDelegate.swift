//
//  AppDelegate.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import Siren
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()

        /// - Warning:
        /// Siren should ONLY be placed in UIApplication.didFinishLaunchingWithOptionsand only after the `window?.makeKeyAndVisible()` call.
        /// Siren initializes a listener on `didBecomeActiveNotification` to perform version checks.

//        defaultExample()
        defaultExampleUsingCompletionHandler()
//        minimalCustomizationPresentationExample()
//        forceLocalizationCustomizationPresentationExample()
//        customMessagingPresentationExample()
//        annoyingRuleExample()
//        hyperCriticalRulesExample()
//        updateSpecificRulesExample()
//        customAlertRulesExample()
//        appStoreCountryChangeExample()
//        complexExample()

        return true
    }
}

// Siren Examples

private extension AppDelegate {

    /// The simplest implementation of Siren.
    /// All default rules are implemented and the
    /// results of the completion handler are ignored.
    func defaultExample() {
        Siren.shared.wail()
    }

    /// The simplest implementation of Siren.
    /// All default rules are implemented and the
    /// results of the completion handler are returned or an error is returned.
    func defaultExampleUsingCompletionHandler() {
        Siren.shared.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// Minor customization to Siren's update alert presentation.
    func minimalCustomizationPresentationExample() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(alertTintColor: .purple,
                                                        appName: "Siren Example App Override!")
        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// Forcing the language of the update alert to a specific localization (e.g., Russian in this function.
    func forceLocalizationCustomizationPresentationExample() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(forceLanguageLocalization: .russian)
        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// Example on how to change specific strings in the update alert.
    func customMessagingPresentationExample() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(alertTitle: "Update Now, OK?",
                                                        nextTimeButtonTitle: "Next time, please!?")
        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// How to present an alert every time the app is foregrounded.
    func annoyingRuleExample() {
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .annoying)

        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// How to present an alert every time the app is foregrounded.
    /// This will block the user from using the app until they update the app.
    /// Setting `showAlertAfterCurrentVersionHasBeenReleasedForDays` to `0` IS NOT RECOMMENDED
    /// as it will cause the user to go into an endless loop to the App Store if the JSON results
    /// update faster than the App Store CDN.
    ///
    /// The `0` value is illustrated in this app as an example on how to change how quickly an alert is presented.
    func hyperCriticalRulesExample() {
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .critical,
                                          showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)

        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// Major, Minor, Patch, and Revision specific rules implementations.
    func updateSpecificRulesExample() {
        let siren = Siren.shared
        siren.rulesManager = RulesManager(majorUpdateRules: .annoying,
                                          minorUpdateRules: .default,
                                          patchUpdateRules: .critical,
                                          revisionUpdateRules: Rules(promptFrequency: .weekly, forAlertType: .option))

        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// An example on how to present your own custom alert using Siren's localized Strings and version checking cadence.
    func customAlertRulesExample() {
        let siren = Siren.shared
        // The key for using custom alerts is to set the `alertType` to `.none`.
        // The `Results` type will return localized strings for your app's custom modal presentation.
        // The `promptFrequency` allows you to customize how often Siren performs the version check before returning a non-error result back into your app, prompting your custom alert functionality.
        let rules = Rules(promptFrequency: .immediately, forAlertType: .none)
        siren.rulesManager = RulesManager(globalRules: rules)

        siren.wail { (results, error) in
            if let results = results {
                print("USE THE VALUES FROM THE `RESULTS` DATA STRUCTURE TO BUILD YOUR UPDATE ALERT WITH LOCALIZED STRINGS.")
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// An example on how to change the App Store region that your app in which your app is available.
    // This should only be used if your app is not available in the US App Store.
    // This example function illustrates how this can be done by checking against the Russian App Store.
    func appStoreCountryChangeExample() {
        let siren = Siren.shared
        siren.apiManager = APIManager(countryCode: "RU")

        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    /// An example on how to customize multiple managers at once.
    func complexExample() {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(alertTintColor: .brown,
                                                        appName: "Siren's Complex Rule Example App",
                                                        alertTitle: "Please, Update Now!",
                                                        skipButtonTitle: "Click here to skip!",
                                                        forceLanguageLocalization: .spanish)
        siren.rulesManager = RulesManager(majorUpdateRules: .annoying,
                                          minorUpdateRules: .default,
                                          patchUpdateRules: .critical,
                                          revisionUpdateRules: .relaxed)

        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
