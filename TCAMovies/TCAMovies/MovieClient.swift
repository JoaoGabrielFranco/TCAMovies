//
//  MoviesClient.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//
import Foundation
import ComposableArchitecture

struct MovieClient {
var fetchPopularMovies: () async throws -> [Movie]
var fetchMovieDetails: (Int) async throws -> MovieDetail
}

extension MovieClient: DependencyKey {
static let liveValue = Self(
    fetchPopularMovies: {
        let apiKey = "babc277d0d8a570e611160f511084b7b"
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return movieResponse.results
    },
    fetchMovieDetails: { movieId in
        let apiKey = "babc277d0d8a570e611160f511084b7b"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
        return movieDetail
    }
)
}

extension DependencyValues {
var movieClient: MovieClient {
    get { self[MovieClient.self] }
    set { self[MovieClient.self] = newValue }
}
}
