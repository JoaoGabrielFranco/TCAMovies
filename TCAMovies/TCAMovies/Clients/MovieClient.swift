//
//  MoviesClient.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//
import Foundation
import ComposableArchitecture

struct MovieClient: Sendable {

    // MARK: - Properties
    var fetchPopularMovies: @Sendable () async throws -> [Movie]
    var fetchMovieDetails: @Sendable (Int) async throws -> MovieDetail

}
// MARK: - Dependency
extension MovieClient: DependencyKey {

    static var liveValue = Self.live()

    static func live() -> Self {
        // TODO: usar sempre o `@Dependency(\.apiClient) var apiClient` para os clients. Faca a configuracao do ApiClient.swift
        let apiClient = APIClient()
        return Self(
            fetchPopularMovies: {
                // TODO: Desafio: resolva esse warning!
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
