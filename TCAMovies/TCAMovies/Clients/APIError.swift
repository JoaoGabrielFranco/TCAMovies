//
//  APIError.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 12/02/26.
//

import Foundation
import ComposableArchitecture
// MARK: - Properties
enum APIError: Error, Equatable, Sendable {
    case invalidURL
    case networkError(String)
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(String)
    case unknown
    
    public var message: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .networkError(let msg): return msg
        case .invalidResponse: return "Invalid Response."
        case .httpError(let code): return "Server Error (Code: \(code))."
        case .decodingError(let msg): return "Failed to process data. \(msg)"
        case .unknown: return "Unknown error happened."
        }
    }
}
