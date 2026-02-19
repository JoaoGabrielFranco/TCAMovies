//
//  URL+Extensions.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 12/02/26.
//

import Foundation

extension URL {
    struct TMDB {
        // MARK: - Properties
        private static let apiHost = "api.themoviedb.org"
        private static let imageHost = "image.tmdb.org"
        private static let apiBasePath = "/3"
        
        private static var apiKey: String {
            Bundle.main.object(forInfoDictionaryKey: "MyApiKey") as? String ?? ""
        }
        
        // MARK: - Endpoints
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
                
                components.queryItems = [
                    URLQueryItem(name: "api_key", value: TMDB.apiKey),
                    URLQueryItem(name: "language", value: "en-US")
                ]
                
                return components.url
            }
        }
        
        enum ImageSize: String {
            case w500 = "w500"
            case original = "original"
        }
        // MARK: - Image
        static func imageURL(path: String, size: ImageSize) -> URL? {
            
            let baseURL = "https://image.tmdb.org/t/p"
            
            let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
            
            let finalString = "\(baseURL)/\(size.rawValue)/\(cleanPath)"
            
            return URL(string: finalString)
        }
    }
}
