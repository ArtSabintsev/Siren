//
//  AppStoreCountry.swift
//  Siren
//
//  Created by Harlan Kellaway on 11/9/20.
//  Copyright © 2020 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Region or country of an App Store in which an app can be available.
/// 
/// [List of country codes](https://help.apple.com/app-store-connect/#/dev997f9cf7c)
public struct AppStoreCountry {

    public static let unitedStates: AppStoreCountry = "US"

    /// Raw country code.
    public let code: String?

}

extension AppStoreCountry: Equatable { }
public func == (lhs: AppStoreCountry, rhs: AppStoreCountry) -> Bool {
    return lhs.code?.uppercased() == rhs.code?.uppercased()
}

extension AppStoreCountry: ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
      self.init(code: value)
    }

}
