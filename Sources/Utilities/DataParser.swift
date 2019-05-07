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
    
    static func isComparedVersionNewer(installedVersion: String?, comparedVersion: String?) -> Bool {
        guard let installedVersion = installedVersion,
            let comparedVersion = comparedVersion,
            (installedVersion.compare(comparedVersion, options: .numeric) == .orderedAscending) else {
                return false
        }
        
        return true
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

        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame else {
                return false
        }

        return true
    }

    /// The type of update that is returned from the API in relation to the verison of the app that is installed.
    ///
    /// - Parameters:
    ///   - installedVersion: The installed version of the app.
    ///   - appStoreVersion: The App Store version of the app.
    /// - Returns: The type of update in relation to the verison of the app that is installed.
    static func parseForUpdate(forInstalledVersion installedVersion: String?,
                               andAppStoreVersion appStoreVersion: String?) -> RulesManager.UpdateType {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion else {
                return .unknown
        }

        let oldVersion = split(version: installedVersion)
        let newVersion = split(version: appStoreVersion)

        guard let newVersionFirst = newVersion.first,
            let oldVersionFirst = oldVersion.first else {
            return .unknown
        }

        if newVersionFirst > oldVersionFirst { // A.b.c.d
            return .major
        } else if newVersion.count > 1 && (oldVersion.count <= 1 || newVersion[1] > oldVersion[1]) { // a.B.c.d
            return .minor
        } else if newVersion.count > 2 && (oldVersion.count <= 2 || newVersion[2] > oldVersion[2]) { // a.b.C.d
            return .patch
        } else if newVersion.count > 3 && (oldVersion.count <= 3 || newVersion[3] > oldVersion[3]) { // a.b.c.D
            return .revision
        } else {
            return .unknown
        }
    }
    
    /// checks if version string is in format x.x.x.x
    static func isVersionStringInAppropriateFormat(versionString: String) -> Bool {
        guard !versionString.isEmpty else {
            return false
        }
        
        var arr = versionString.map( {$0} )
        for (index,element) in arr.enumerated() {
            if element.isNumber {
                if element == "0" && index < arr.count - 1 && arr[index + 1].isNumber {
                    return false
                }
                continue
            } else if element == "." {
                if index == 0 || index == arr.count - 1 {
                    return false
                } else if index < arr.count - 1 && arr[index + 1].isNumber {
                    continue
                }
                return false
            } else {
                return false
            }
        }
        return true
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
