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
    @objc func testSetCurrentInstalledVersion(version: String) {
        currentInstalledVersion = version
    }

    @objc func testSetAppStoreVersion(version: String) {
        currentAppStoreVersion = version
    }

    @objc func testIsAppStoreVersionNewer() -> Bool {
        return isAppStoreVersionNewer()
    }
}
