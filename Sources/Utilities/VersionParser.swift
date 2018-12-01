//
//  VersionParser.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

struct VersionParser {

    static func isAppStoreVersionNewer(installedVersion: String?, appStoreVersion: String?) -> Bool {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion,
            (installedVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending) else {
                return false
        }

        return true
    }

    static func parse(installedVersion: String?, appStoreVersion: String?) -> RulesManager.UpdateType {
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

    private static func split(version: String) -> [Int] {
        return version.lazy.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
    }

}
