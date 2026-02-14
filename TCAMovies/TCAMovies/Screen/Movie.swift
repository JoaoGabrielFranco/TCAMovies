//
//  Movie.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//
import Foundation

public struct Movie: Codable, Identifiable, Equatable {

    // MARK: - Properties
    public let id: Int
    public let title: String
    public let overview: String?
    public let posterPath: String?
    public let voteAverage: Double?
    public let releaseDate: Date?
    public let backdropPath: String?

    // TODO: Pesquise diferenca entre Codable, Decodale e Encodable
    // MARK: - Encodable
    public enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }

    // TODO: Nao poderia utilizar o APIError aqui?
    enum Error: Swift.Error, Equatable {
        case generic(String)
        
        init(_ error: Swift.Error) {
            self = .generic(error.localizedDescription)
        }
    }
    // MARK: - DateFormatter
    var releaseDateFormatted: String {
        // TODO: Queremos mesmo que, caso nao tenha a data, mostremos um "Unknown" na tela do usuario?
        guard let releaseDate else { return "Unknown"}
        
        return releaseDate.formatted(
            .dateTime
                .year()
                .month(.abbreviated)
                .day()
                .locale(Locale(identifier: "en_US"))
        )
    }

    // TODO: Nao consigo reaproveitar algo do URL+Extensions?
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

struct MovieResponse: Codable, Equatable {
    let results: [Movie]
}
