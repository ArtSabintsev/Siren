//
//  SirenEitherType.swift
//  Siren
//
//  Created by Daniel Lin on 2018/10/26.
//

import Foundation

public enum SirenEitherType<L, R> {
    case left(L)
    case right(R)
}

extension SirenEitherType: Decodable where L: Decodable, R: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let left = try? container.decode(L.self) {
            self = .left(left)
        } else if let right = try? container.decode(R.self) {
            self = .right(right)
        } else {
            throw DecodingError.typeMismatch(SirenEitherType<L, R>.self, .init(codingPath: decoder.codingPath, debugDescription: "Type expected either `\(L.self)` or `\(R.self)`"))
        }
    }
}

extension SirenEitherType: Encodable where L: Encodable, R: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .left(left):
            try container.encode(left)
        case let .right(right):
            try container.encode(right)
        }
    }
}
