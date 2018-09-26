//
//  SirenLog.swift
//  SirenExample
//
//  Created by Arthur Sabintsev on 8/5/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Log and decorate Siren-specific messages to the console.

struct SirenLog {
    @discardableResult
    init(_ message: String) {
        print("[Siren] \(message)")
    }
}
