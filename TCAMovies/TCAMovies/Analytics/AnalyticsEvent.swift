//
//  AnalyticsEvent.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 13/02/26.
//

import Foundation
// MARK: - Properties
struct AnalyticsEvent: Sendable {
    let name: String
    let parameters: [String: any Sendable]?
    
    // MARK: - Initializers
    init(name: String, parameters: [String: any Sendable]? = nil) {
        self.name = name
        self.parameters = parameters
    }
}
