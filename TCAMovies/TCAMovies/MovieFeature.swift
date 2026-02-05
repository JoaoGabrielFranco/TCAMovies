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
    }
    
    enum Action: Equatable {
        case fetchMovies
        case moviesResponse(TaskResult<[Movie]>)
    }
    
    @Dependency(\.movieClient) var movieClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMovies:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    await send(.moviesResponse(
                        TaskResult {try await movieClient.fetchPopularMovies()}
                    ))
                }
            case let .moviesResponse(.success(movies)):
                state.isLoading = false
                state.movies = movies
                return .none
            case let .moviesResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
            
        }
    }
}
