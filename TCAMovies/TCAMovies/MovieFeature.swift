//
//  MovieFeature.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//
import Foundation
import ComposableArchitecture

@Reducer
struct MovieFeature {
@ObservableState
struct State: Equatable {
    var movies: [Movie] = []
    var isLoading = false
    var errorMessage: String?
    @Presents var movieDetail: MovieDetailFeature.State?
}

enum Action: Equatable {
    case fetchMovies
    case moviesResponse(Result<[Movie], Error>)
    case movieTapped(Movie)
    case movieDetail(PresentationAction<MovieDetailFeature.Action>)
    
    static func == (lhs: Action, rhs: Action) -> Bool {
        switch (lhs, rhs) {
        case (.fetchMovies, .fetchMovies):
            return true
        case let (.moviesResponse(.success(lhsMovies)), .moviesResponse(.success(rhsMovies))):
            return lhsMovies == rhsMovies
        case (.moviesResponse(.failure), .moviesResponse(.failure)):
            return true
        case let (.movieTapped(lhsMovie), .movieTapped(rhsMovie)):
            return lhsMovie == rhsMovie
        case let (.movieDetail(lhsAction), .movieDetail(rhsAction)):
            return lhsAction == rhsAction
        default:
            return false
        }
    }
}

@Dependency(\.movieClient) var movieClient

var body: some Reducer<State, Action> {
    Reduce { state, action in
        switch action {
        case .fetchMovies:
            state.isLoading = true
            state.errorMessage = nil
            
            return .run { send in
                do {
                    let movies = try await movieClient.fetchPopularMovies()
                    await send(.moviesResponse(.success(movies)))
                } catch {
                    await send(.moviesResponse(.failure(error)))
                }
            }
            
        case let .moviesResponse(.success(movies)):
            state.isLoading = false
            state.movies = movies
            return .none
            
        case let .moviesResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.localizedDescription
            return .none
            
        case let .movieTapped(movie):
            state.movieDetail = MovieDetailFeature.State(movieId: movie.id)
            return .none
            
        case .movieDetail:
            return .none
        }
    }
    .ifLet(\.$movieDetail, action: \.movieDetail) {
        MovieDetailFeature()
    }
}
}
