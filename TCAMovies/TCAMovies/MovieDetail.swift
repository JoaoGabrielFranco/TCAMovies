//
//  MovieDetail.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import Foundation

struct MovieDetail: Codable, Equatable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let releaseDate: Date?
    let runtime: Int?
    let genres: [Genre]?
    let budget: Int?
    let revenue: Int?
    let tagline: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, budget, revenue, tagline
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
    enum Error: Swift.Error, Equatable, Sendable {
        case generic(String)
        
        // Inicializador conveniente para converter erros do sistema
        init(_ error: Swift.Error) {
            self = .generic(error.localizedDescription)
        }
    }
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL.TMDB.imageURL(path: posterPath, size: .w500)
    }
    
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL.TMDB.imageURL(path: backdropPath, size: .original)
    }
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
    struct Genre: Codable, Equatable, Identifiable {
        let id: Int
        let name: String
    }
}


