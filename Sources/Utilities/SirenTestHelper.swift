//
//  SirenTestHelper.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 4/8/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Test Target Helpers

extension Siren {
    func testSetCurrentInstalledVersion(version: String) {
        currentInstalledVersion = version
    }

    func testSetAppStoreVersion(version: String) {
        currentAppStoreVersion = version
    }

    func testIsAppStoreVersionNewer() -> Bool {
        return isAppStoreVersionNewer()
    }
}
