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
let releaseDate: String?
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

var posterURL: URL? {
    guard let posterPath else { return nil }
    return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
}

var backdropURL: URL? {
    guard let backdropPath else { return nil }
    return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
}

var runtimeFormatted: String? {
    guard let runtime else { return nil }
    let hours = runtime / 60
    let minutes = runtime % 60
    return "\(hours)h \(minutes)min"
}
}

struct Genre: Codable, Equatable, Identifiable {
let id: Int
let name: String
}
