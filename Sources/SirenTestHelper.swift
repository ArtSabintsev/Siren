//
//  SirenTestHelper.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 4/8/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Helpers (Testing Target)

extension Siren {
    func testSetCurrentInstalledVersion(_ version: String) {
        currentInstalledVersion = version
    }

    func testSetAppStoreVersion(_ version: String) {
        currentAppStoreVersion = version
    }

    func testIsAppStoreVersionNewer() -> Bool {
        return isAppStoreVersionNewer()
    }
}
