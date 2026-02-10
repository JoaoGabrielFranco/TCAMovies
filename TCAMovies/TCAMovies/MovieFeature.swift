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
    var searchText = ""
    var filteredMovies: [Movie] {
        if searchText.isEmpty{
            return movies
        } else {
            return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

enum Action: BindableAction, Equatable {
    case fetchMovies
    case binding(BindingAction<State>)
    case moviesResponse(Result<[Movie], Error>)
    case movieTapped(Movie)
    case movieDetail(PresentationAction<MovieDetailFeature.Action>)
    
    static func == (lhs: Action, rhs: Action) -> Bool {
        switch (lhs, rhs) {
        case (.binding(let l), .binding(let r)): return l == r
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
    
    BindingReducer()
    
    Reduce { state, action in
        switch action {
        case .binding:
            return .none
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
