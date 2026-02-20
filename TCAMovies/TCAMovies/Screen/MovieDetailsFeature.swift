//
//  MovieDetailFeature.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 09/02/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieDetailsFeature: Sendable {
    // MARK: - State
    @ObservableState
    
    struct State: Equatable {
        // MARK: - Properties
        let movieID: Int
        let movieTitle: String
        var movieDetail: MovieDetail?
        var status: Status = .default
        var isLoading: Bool {
            return status == .loading
        }
        var errorMessage: String? {
            if case let .toast(config) = status {
                return config?.message
            }
            return nil
        }
    }
    
    // MARK: - Action
    enum Action: Equatable {
        case fetchMovieDetails
        case handleMovieDetailsResponse(Result<MovieDetail, APIError>)
        case onAppear
    }
    // MARK: - Properties
    @Dependency(\.analyticsClient) var analytics
    @Dependency(\.movieClient) var movieClient
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .run { [id = state.movieID, title = state.movieTitle] send in
                    
                    
                    await analytics.logEvent(.viewMovieDetail(id: id, title: title))
                    
                    await send(.fetchMovieDetails)
                }
                
            case .fetchMovieDetails:
                state.status = .loading
                
                return .run { [movieID = state.movieID] send in
                    do {
                        let detail = try await movieClient.fetchMovieDetails(movieID)
                        
                        
                        await send(.handleMovieDetailsResponse(.success(detail)))
                        
                    } catch {
                        let apiError = error as? APIError ?? .networkError(error.localizedDescription)
                        await send(.handleMovieDetailsResponse(.failure(apiError)))
                    }
                }
                
                
            case let .handleMovieDetailsResponse(result):
                switch result {
                case let .success(detail):
                    state.status = .default
                    state.movieDetail = detail
                    
                case let .failure(error):
                    
                    state.status = .toast(ToastConfiguration(
                        title: "Loading Error",
                        message: error.message,
                        type: .error
                    ))
                }
                return .none
            }
        }
    }
    
}
// MARK: - ActionProperties
enum Status: Equatable, Sendable {
    case `default`
    case loading
    case submitted
    case toast(ToastConfiguration?)
}
struct ToastConfiguration: Equatable, Sendable {
    public let title: String
    public let message: String
    public let type: ToastType
}

enum ToastType: Equatable, Sendable {
    case error
}
