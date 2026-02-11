//
//  MoviesClient.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import Foundation
import ComposableArchitecture

// TODO: Faça MovieClient conformar com Sendable. Isso é importante no TCA e no Swift Concurrency, pois:
// No TCA, as dependências como `MovieClient` são frequentemente injetadas em Reducers e
// utilizadas dentro de `Effect.run` ou `Task`s, que podem ser executados em diferentes
// *actors* ou *threads* de forma concorrente.
struct MovieClient/*: Sendable*/ {

    // MARK: - Properties
    var fetchPopularMovies: /*@Sendable*/ () async throws -> [Movie]
    var fetchMovieDetails: /*@Sendable*/ (Int) async throws -> MovieDetail
}

extension MovieClient: DependencyKey {
    static let liveValue = Self(
        fetchPopularMovies: {

            // TODO: Não é aconselhavel chaves de APIs expostas dessa forma, existem outras maneiras de acessa-las no codigo. Pesquise essas outras formas, como o Info.plist
            let apiKey = "babc277d0d8a570e611160f511084b7b"

            // TODO: É possível criar extensions de classes nativas do Swift, experimente criar uma extension URL para centralizar as base URL's. Tenha um arquivo de URL+Extensions.swift
            let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US"
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            // TODO: Crie um APIClient para fazer as chamadas de API, passando a URL e o tipo de response para modularizar. Veja no nosso projeto como o APIClient funciona. Replique essa logica para simplificar ambos os fetchs
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
