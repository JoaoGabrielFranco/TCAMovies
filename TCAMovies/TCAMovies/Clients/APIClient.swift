//
//  APIClient.swift
//  TCAMovies
//
//  Created by dti on 12/02/26.
//

import Foundation

struct APIClient {
    // MARK: - DateFormatter
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //MARK: - Interface
    
    func request<T: Decodable>(endpoint: URL.TMDB.Endpoint) async throws -> T {
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Erro HTTP: \(httpResponse.statusCode)")
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            return try decoder.decode(T.self, from: data)
            
        } catch let error as APIError {
            throw error 
        } catch let error as DecodingError {
            print("Erro de Decodificação: \(error)")
            throw APIError.decodingError(error)
        } catch {
            print("Erro de Rede: \(error)")
            throw APIError.networkError(error)
        }
    }
}
