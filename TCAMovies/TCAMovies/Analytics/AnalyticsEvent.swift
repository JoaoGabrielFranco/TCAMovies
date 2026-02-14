//
//  AnalyticsEvent.swift
//  TCAMovies
//  TODO: Desafio: Procure como configurar para que os arquivos gerados ja venham com seu nome por default ao inves de dti
//  Created by dti on 13/02/26.
//

import Foundation

struct AnalyticsEvent: Sendable {

    // MARK: - Properties
    let name: String
    let parameters: [String: any Sendable]?
    
    // MARK: - Initializers
    init(name: String, parameters: [String: any Sendable]? = nil) {
        self.name = name
        self.parameters = parameters
    }
}
