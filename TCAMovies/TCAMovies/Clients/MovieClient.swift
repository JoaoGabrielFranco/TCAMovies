//
//  MoviesClient.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 05/02/26.
//
import ComposableArchitecture

struct MovieClient: Sendable {
    // MARK: Properties
    var fetchPopularMovies: @Sendable () async throws -> [Movie]
    var fetchMovieDetails: @Sendable (Int) async throws -> MovieDetail
    
}

// MARK: - Dependency
extension MovieClient: DependencyKey {
    static var liveValue: MovieClient {
        @Dependency(\.apiClient) var apiClient
        
        return Self(
            fetchPopularMovies: {
                let response: MovieResponse = try await apiClient.request(.popularMovies)
                return response.results
            }, fetchMovieDetails: { id in
                return try await apiClient.request(.movieDetails(id: id))
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
