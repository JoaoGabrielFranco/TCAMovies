//
//  MovieDetail.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import Foundation

public struct MovieDetail: Codable, Equatable, Identifiable {

    // MARK: - Properties
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
    
    // MARK: - Encoder
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, budget, revenue, tagline
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }

    // MARK: - Error
    // TODO: Mesmo questionamento do APIError
    public enum Error: Swift.Error, Equatable, Sendable {
        case generic(String)
        
        init(_ error: Swift.Error) {
            self = .generic(error.localizedDescription)
        }
    }
    // MARK: - Requests
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL.TMDB.imageURL(path: posterPath, size: .w500)
    }
    
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL.TMDB.imageURL(path: backdropPath, size: .original)
    }

    // TODO: Repeticao de codigo do Movie.swiftt?
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
    // MARK: - TimeFormatter
    // TODO: Desafio: Entender como isso e feito no projeto, levando em conta que rodamos o app no brasil e nos EUA
    var runtimeFormatted: String? {
        guard let runtime else { return nil }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        
        // TODO: let
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US")
        formatter.calendar = calendar
        
        let timeInSeconds = TimeInterval(runtime * 60)
        return formatter.string(from: timeInSeconds)
    }
    public struct Genre: Codable, Equatable, Identifiable {
        public let id: Int
        public let name: String
    }
}


// TODO: Esta muito baguncado as informacoes nesse arquivo. De uma olhada no projetoTO com os MARKS: Interface, Properties, Helper...
