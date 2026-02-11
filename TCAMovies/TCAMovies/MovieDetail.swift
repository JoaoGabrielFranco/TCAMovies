//
//  MovieDetail.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import Foundation

struct MovieDetail: Codable, Equatable, Identifiable, Sendable {

    // MARK: - Properties
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    // TODO: Considere transformar `releaseDate: String?` em `releaseDate: Date?`. Nao e seguro usar String(releaseDate.prefix(4)) na view
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]?
    let budget: Int?
    let revenue: Int?
    let tagline: String?

    // MARK: - Interface
    // TODO: É possível criar extensions de classes nativas do Swift, experimente criar uma extension URL para centralizar as base URL's. Tenha um arquivo de URL+Extensions.swift
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
    }

    // TODO: Remova a logica manual de parsing, dê uma pesquisada sobre classes de formatação, como DateComponentsFormatter()
    var runtimeFormatted: String? {
        guard let runtime else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)min"
    }

    // MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, budget, revenue, tagline
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

// TODO: Não faz sentido acessar o objeto `Genre` fora do contexto de Movies. mova para uma struct interna dentro de MovieDetails
// MARK: - MovieDetails.Genre
struct Genre: Codable, Equatable, Identifiable, Sendable {

    // MARK: - Properties
    let id: Int
    let name: String
}
