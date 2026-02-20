//
//  Movie.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 05/02/26.
//

import Foundation

// MARK: - Properties
public struct Movie: Codable, Sendable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let overview: String?
    public let posterPath: String?
    public let voteAverage: Double?
    public let releaseDate: Date?
    public let backdropPath: String?
    
    // MARK: - Encodable
    public enum CodingKeys: String, CodingKey, Sendable {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
    
}

// MARK: - Helpers
extension Movie {
    public var releaseDateFormatted: String {
        guard let releaseDate = releaseDate else { return "" }
        
        return releaseDate.formatted(date: .abbreviated, time: .omitted)
    }
    public var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL.TMDB.imageURL(path: posterPath, size: .w500)
    }
}

// MARK: - MovieResponse
public struct MovieResponse: Codable, Equatable, Sendable {
    public let results: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    nonisolated public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([Movie].self, forKey: .results)
    }
    
    nonisolated public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results, forKey: .results)
    }
}
