//
//  MovieDetail.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 09/02/26.
//

import Foundation

// MARK: - Properties
public struct MovieDetail: Codable, Equatable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String?
    public let posterPath: String?
    public let backdropPath: String?
    public let voteAverage: Double?
    public let releaseDate: Date?
    public let runtime: Int?
    public let genres: [Genre]?
    public let budget: Int?
    public let revenue: Int?
    public let tagline: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey, Sendable {
        case id, title, overview, runtime, genres, budget, revenue, tagline
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
    // MARK: - Non-isolated Init
    nonisolated public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.releaseDate = try container.decodeIfPresent(Date.self, forKey: .releaseDate)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
    }
    
    // MARK: - Encoder
    nonisolated public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(overview, forKey: .overview)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(runtime, forKey: .runtime)
        try container.encode(genres, forKey: .genres)
        try container.encode(budget, forKey: .budget)
        try container.encode(revenue, forKey: .revenue)
        try container.encode(tagline, forKey: .tagline)
    }
    
    // MARK: - Subtypes
    public struct Genre: Codable, Equatable, Identifiable, Sendable {
        public let id: Int
        public let name: String
    }
    
}

// MARK: - Extensions
public extension MovieDetail {
    // MARK: - Requests
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL.TMDB.imageURL(path: posterPath, size: .w500)
    }
    
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL.TMDB.imageURL(path: backdropPath, size: .original)
    }
    
    // MARK: - Formatters
    var releaseDateFormatted: String {
        guard let releaseDate else { return ""}
        
        return releaseDate.formatted(
            .dateTime
                .year()
                .month(.abbreviated)
                .day()
                .locale(Locale(identifier: "en_US"))
        )
    }
    
    // MARK: - TimeFormatter
    var runtimeFormatted: String? {
        guard let runtime else { return nil }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US")
        formatter.calendar = calendar
        
        let timeInSeconds = TimeInterval(runtime * 60)
        return formatter.string(from: timeInSeconds)
    }
}
