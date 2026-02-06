//
//  MoviesClient.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct MovieClient {
    var fetchPopularMovies: @Sendable () async throws -> [Movie]
}
extension MovieClient: DependencyKey {
    static let liveValue = MovieClient(
    
        fetchPopularMovies: {
            let apiKey = "babc277d0d8a570e611160f511084b7b"
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US")!
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
                    if let httpResponse = response as? HTTPURLResponse {
                        print("📡 Status Code:", httpResponse.statusCode)
                    }
                    
    
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("📄 JSON Response:", jsonString.prefix(500))
                    }
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results
            
        }
        
        )
}

extension DependencyValues {
var movieClient: MovieClient {
    get { self[MovieClient.self] }
    set { self[MovieClient.self] = newValue }
}
}
