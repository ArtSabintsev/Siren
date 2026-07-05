//
//  DataParser.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// Version parsing functions for Siren.
struct DataParser {
    /// Checks to see if the App Store version of the app is newer than the installed version.
    ///
    /// - Parameters:
    ///   - installedVersion: The installed version of the app.
    ///   - appStoreVersion: The App Store version of the app.
    /// - Returns: `true` if the App Store version is newer. Otherwise, `false`.
    static func isAppStoreVersionNewer(installedVersion: String?, appStoreVersion: String?) -> Bool {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion else {
                return false
        }

        return compare(split(version: installedVersion), split(version: appStoreVersion)) == .orderedAscending
    }

    /// Validates that the latest version in the App Store is compatible with the device's current version of iOS.
    ///
    /// - Parameter model: The iTunes Lookup Model.
    /// - Returns: `true` if the latest version is compatible with the device's current version of iOS. Otherwise, `false`.
    static func isUpdateCompatibleWithDeviceOS(for model: APIModel) -> Bool {
        guard let requiredOSVersion = model.results.first?.minimumOSVersion else {
            return false
        }

        let systemVersion = UIDevice.current.systemVersion

        return compare(split(version: systemVersion), split(version: requiredOSVersion)) != .orderedAscending
    }

    /// The type of update that is returned from the API in relation to the version of the app that is installed.
    ///
    /// - Parameters:
    ///   - installedVersion: The installed version of the app.
    ///   - appStoreVersion: The App Store version of the app.
    /// - Returns: The type of update in relation to the version of the app that is installed.
    static func parseForUpdate(forInstalledVersion installedVersion: String?,
                               andAppStoreVersion appStoreVersion: String?) -> RulesManager.UpdateType {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion else {
                return .unknown
        }

        let oldVersion = split(version: installedVersion)
        let newVersion = split(version: appStoreVersion)

        for index in 0..<Swift.max(oldVersion.count, newVersion.count) {
            let oldComponent = component(of: oldVersion, at: index)
            let newComponent = component(of: newVersion, at: index)

            guard newComponent != oldComponent else { continue }
            guard newComponent > oldComponent else { return .unknown }

            switch index {
            case 0: return .major   // A.b.c.d
            case 1: return .minor   // a.B.c.d
            case 2: return .patch   // a.b.C.d
            default: return .revision // a.b.c.D
            }
        }

        return .unknown
    }

    /// Compares two split version numbers component by component,
    /// treating missing components as zero (e.g., "2.3" is equal to "2.3.0").
    ///
    /// - Parameters:
    ///   - lhs: The left-hand version, as returned by `split(version:)`.
    ///   - rhs: The right-hand version, as returned by `split(version:)`.
    /// - Returns: The ordering of the two versions.
    private static func compare(_ lhs: [Int], _ rhs: [Int]) -> ComparisonResult {
        for index in 0..<Swift.max(lhs.count, rhs.count) {
            let lhsComponent = component(of: lhs, at: index)
            let rhsComponent = component(of: rhs, at: index)

            if lhsComponent < rhsComponent {
                return .orderedAscending
            } else if lhsComponent > rhsComponent {
                return .orderedDescending
            }
        }

        return .orderedSame
    }

    /// Returns the version component at a given index, or zero when the index is out of bounds.
    ///
    /// - Parameters:
    ///   - version: A split version number.
    ///   - index: The component index.
    /// - Returns: The component's value, or `0` if the version has no component at that index.
    private static func component(of version: [Int], at index: Int) -> Int {
        return index < version.count ? version[index] : 0
    }

    /// Splits a version-formatted `String into an `[Int]`.
    ///
    /// Converts `"a.b.c.d"` into `[a, b, c, d]`.
    ///
    /// - Parameter version: The version formatted `String`.
    ///
    /// - Returns: An array of integers representing a version of the app.
    private static func split(version: String) -> [Int] {
        return version.lazy.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
    }
}
