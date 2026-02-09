//
//  MovieDetailFeature.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieDetailFeature {
@ObservableState
struct State: Equatable {
    let movieId: Int
    var movieDetail: MovieDetail?
    var isLoading = false
    var errorMessage: String?
}

enum Action: Equatable {
    case fetchMovieDetails
    case movieDetailsResponse(Result<MovieDetail, Error>)
    
    static func == (lhs: Action, rhs: Action) -> Bool {
        switch (lhs, rhs) {
        case (.fetchMovieDetails, .fetchMovieDetails):
            return true
        case let (.movieDetailsResponse(.success(lhsMovie)), .movieDetailsResponse(.success(rhsMovie))):
            return lhsMovie == rhsMovie
        case (.movieDetailsResponse(.failure), .movieDetailsResponse(.failure)):
            return true
        default:
            return false
        }
    }
}

@Dependency(\.movieClient) var movieClient

var body: some Reducer<State, Action> {
    Reduce { state, action in
        switch action {
        case .fetchMovieDetails:
            state.isLoading = true
            state.errorMessage = nil
            
            return .run { [movieId = state.movieId] send in
                do {
                    let movieDetail = try await movieClient.fetchMovieDetails(movieId)
                    await send(.movieDetailsResponse(.success(movieDetail)))
                } catch {
                    await send(.movieDetailsResponse(.failure(error)))
                }
            }
            
        case let .movieDetailsResponse(.success(movieDetail)):
            state.isLoading = false
            state.movieDetail = movieDetail
            return .none
            
        case let .movieDetailsResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.localizedDescription
            return .none
        }
    }
}
}
