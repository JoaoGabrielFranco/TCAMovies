//
//  APIError.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 12/02/26.
//

import Foundation
// MARK: - Properties
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown
}
