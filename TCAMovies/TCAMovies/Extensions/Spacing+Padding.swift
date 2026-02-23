//
//  Spacing+Padding.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 20/02/26.
//
import SwiftUI
public struct Spacing: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, Sendable {

    // MARK: - Properties
    public var rawValue: CGFloat

    // MARK: - Initializers
    public init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }
    public init(floatLiteral value: FloatLiteralType) {
            self.init(rawValue: CGFloat(value))
        }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: CGFloat(value))
    }

    // MARK: - Preset
    public static let zero: Self = .init(rawValue: 0)
    public static let extraExtraExtraSmall: Self = .init(rawValue: 4)
    public static let extraExtraSmall: Self = .init(rawValue: 6)
    public static let extraSmall: Self = .init(rawValue: 8)
    public static let small: Self = .init(rawValue: 10)
    public static let medium: Self = .init(rawValue: 12)
    public static let large: Self = .init(rawValue: 16)
    public static let extraLarge: Self = .init(rawValue: 20)
    public static let extraExtraLarge: Self = .init(rawValue: 32)
    public static let extraExtraExtraLarge: Self = .init(rawValue: 50)
    
    
}
