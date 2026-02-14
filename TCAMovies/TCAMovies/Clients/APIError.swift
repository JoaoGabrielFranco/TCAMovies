//
//  APIError.swift
//  TCAMovies
//
//  Created by dti on 12/02/26.
//

import Foundation

enum APIError: Error {

    case invalidURL
    case networkError(Error)
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown
}
