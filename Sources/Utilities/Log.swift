//
//  Log.swift
//  Siren
//
//  Created by Arthur Sabintsev on 8/5/17.
//  Copyright © 2017 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// Log and decorate Siren-specific messages to the console.
struct Log {
    @discardableResult
    init(_ message: String) {
        print("[Siren] \(message)")
    }
}
