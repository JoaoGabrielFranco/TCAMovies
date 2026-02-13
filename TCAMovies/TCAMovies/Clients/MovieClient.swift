//
//  MoviesClient.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//
import Foundation
import ComposableArchitecture

struct MovieClient: Sendable {
    // MARK: Properties
    var fetchPopularMovies: @Sendable () async throws -> [Movie]
    var fetchMovieDetails: @Sendable (Int) async throws -> MovieDetail
    
}
// MARK: - Dependency
extension MovieClient: DependencyKey {
    static var liveValue = Self.live()
    static func live() -> Self {
        let apiClient = APIClient()
        return Self(
            fetchPopularMovies: {
                let response: MovieResponse = try await apiClient.request(endpoint: .popularMovies)
                return response.results
            }, fetchMovieDetails: { id in
                return try await apiClient.request(endpoint: .movieDetails(id: id))
            }
        )
    }
    
}

extension DependencyValues {
    var movieClient: MovieClient {
        get { self[MovieClient.self] }
        set { self[MovieClient.self] = newValue }
    }
}
