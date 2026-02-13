//
//  Movie.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//
import Foundation

// MARK: - Properties
public struct Movie: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let overview: String?
    public let posterPath: String?
    public let voteAverage: Double?
    public let releaseDate: Date?
    public let backdropPath: String?
    // MARK: - Encodable
    public enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
    enum Error: Swift.Error, Equatable {
        case generic(String)
        
        init(_ error: Swift.Error) {
            self = .generic(error.localizedDescription)
        }
    }
    // MARK: - DateFormatter
    var releaseDateFormatted: String {
        guard let releaseDate else { return "Unknown"}
        
        return releaseDate.formatted(
            .dateTime
                .year()
                .month(.abbreviated)
                .day()
                .locale(Locale(identifier: "en_US"))
        )
    }
    // MARK: - PosterURL
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

struct MovieResponse: Codable, Equatable {
    let results: [Movie]
}
