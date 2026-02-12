//
//  APIClient.swift
//  TCAMovies
//
//  Created by dti on 12/02/26.
//

import Foundation

struct APIClient {
    
    // Configuração do Decoder (TMDB usa snake_case, Swift usa camelCase)
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Função Genérica: <T: Decodable> significa "qualquer coisa que possa ser decodificada"
    func request<T: Decodable>(endpoint: URL.TMDB.Endpoint) async throws -> T {
        
        // 1. Valida a URL vinda do endpoint
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        do {
            // 2. Faz a chamada de rede
            let (data, response) = try await session.data(from: url)
            
            // 3. Valida se a resposta é HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // 4. Valida o Status Code (200 a 299 é sucesso)
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Erro HTTP: \(httpResponse.statusCode)")
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            // 5. Decodifica os dados para o tipo T esperado
            return try decoder.decode(T.self, from: data)
            
        } catch let error as APIError {
            throw error // Repassa erros nossos
        } catch let error as DecodingError {
            print("Erro de Decodificação: \(error)")
            throw APIError.decodingError(error)
        } catch {
            print("Erro de Rede: \(error)")
            throw APIError.networkError(error)
        }
    }
}
