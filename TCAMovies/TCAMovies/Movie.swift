//
//  Movie.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//
import Foundation

// MARK: - Properties
struct Movie: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    let releaseDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    enum Error: Swift.Error, Equatable {
        case generic(String)
        
        init(_ error: Swift.Error) {
            self = .generic(error.localizedDescription)
        }
    }
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

struct MovieResponse: Codable, Equatable {
    let results: [Movie]
}
