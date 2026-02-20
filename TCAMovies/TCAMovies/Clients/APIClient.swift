//
//  APIClient.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 12/02/26.
//

import Foundation
import ComposableArchitecture

struct APIClient: Sendable {
    // MARK: - Properties
    var request: @Sendable (URL.TMDB.Endpoint) async throws -> Data
    
    
    func request<T: Decodable>(_ endpoint: URL.TMDB.Endpoint) async throws -> T {
        let data = try await self.request(endpoint)
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return try decoder.decode(T.self, from: data)
    }
}

extension APIClient: DependencyKey {
    static var liveValue: APIClient = .live
    
    static var live: Self {
        return Self(
            request: { endpoint in
                
                guard let url = await endpoint.url else {
                    throw APIError.invalidURL
                }
                
                let session = URLSession.shared
                
                do {
                    let (data, response) = try await session.data(from: url)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.invalidResponse
                    }
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        throw APIError.httpError(statusCode: httpResponse.statusCode)
                    }
                    
                    return data
                    
                } catch let error as APIError {
                    throw error
                } catch {
                    throw APIError.networkError(error)
                }
            }
        )
    }
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
