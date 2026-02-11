//
//  Movie.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import Foundation

// TODO: Atencao a formatacao dos arquivos comando: control + i
struct Movie: Codable, Identifiable, Equatable, Sendable {

    // MARK: - Properties
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    // TODO: Considere a data sendo um `Date?`. Para isso vai precisar de um init customizado
    let releaseDate: String?

    // MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }

    // TODO: É possível criar extensions de classes nativas do Swift, experimente criar uma extension URL para centralizar as base URL's. Tenha um arquivo de URL+Extensions.swift
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

// MARK: - MovieResponse
struct MovieResponse: Codable, Equatable, Sendable {

    // MARK: - Properties
    let results: [Movie]
}
