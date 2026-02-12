//
//  URL+Extensions.swift
//  TCAMovies
//
//  Created by dti on 12/02/26.
//

import Foundation

extension URL {
    struct TMDB {
        // MARK: - Configurações
        private static let apiHost = "api.themoviedb.org"
        private static let imageHost = "image.tmdb.org"
        private static let apiBasePath = "/3"
        
        private static var apiKey: String {
            Bundle.main.object(forInfoDictionaryKey: "MyApiKey") as? String ?? ""
        }
        
        // MARK: - 1. Endpoints de DADOS (JSON)
        enum Endpoint {
            case popularMovies
            case movieDetails(id: Int)
            
            var path: String {
                switch self {
                case .popularMovies: return "/movie/popular"
                case .movieDetails(let id): return "/movie/\(id)"
                }
            }
            
            var url: URL? {
                var components = URLComponents()
                components.scheme = "https"
                components.host = TMDB.apiHost
                components.path = TMDB.apiBasePath + self.path
                
                // Query Params (API Key, Language)
                components.queryItems = [
                    URLQueryItem(name: "api_key", value: TMDB.apiKey),
                    URLQueryItem(name: "language", value: "en-US")
                ]
                
                return components.url
            }
        }
        
        // MARK: - 2. Endpoints de IMAGEM (JPG)
        // Imagens não usam API Key na URL e têm outro Host
        enum ImageSize: String {
            case w500 = "/t/p/w500"
            case original = "/t/p/original"
        }
        
        static func imageURL(path: String, size: ImageSize) -> URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = TMDB.imageHost
            components.path = size.rawValue + path
            return components.url
        }
    }
}
