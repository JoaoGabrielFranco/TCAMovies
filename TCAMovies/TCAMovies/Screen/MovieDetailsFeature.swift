//
//  MovieDetailFeature.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct MovieDetailsFeature {
    // MARK: - State
    @ObservableState
    
    public struct State: Equatable {
        // MARK: - Properties
        public let movieID: Int
        public let movieTitle: String
        public var movieDetail: MovieDetail?
        public var status: Status = .default
        public var isLoading: Bool {
            return status == .loading
        }
        public var errorMessage: String? {
            if case let .toast(config) = status {
                return config?.message
            }
            return nil
        }
    }
    
    // MARK: - Action
    public enum Action: Equatable {
        case fetchMovieDetails
        case handleMovieDetailsResponse(Result<MovieDetail, MovieDetail.Error>)
        case onAppear
    }
    // MARK: - Properties
    @Dependency(\.analyticsClient) var analytics
    @Dependency(\.movieClient) var movieClient
    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
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
                        let customError = MovieDetail.Error(error)
                        await send(.handleMovieDetailsResponse(.failure(customError)))
                    }
                }
                
                
            case let .handleMovieDetailsResponse(result):
                switch result {
                case let .success(detail):
                    state.status = .default
                    state.movieDetail = detail
                    
                case let .failure(error):
                    
                    let message: String
                    switch error {
                    case let .generic(msg):
                        message = msg
                    }
                    
                    state.status = .toast(ToastConfiguration(
                        title: "Error",
                        message: message,
                        type: .error
                    ))
                }
                return .none
            }
        }
    }
    
}
// MARK: - ActionProperties
public enum Status: Equatable, Sendable {
    case `default`
    case loading
    case submitted
    case toast(ToastConfiguration?)
}
public struct ToastConfiguration: Equatable, Sendable {
    public let title: String
    public let message: String
    public let type: ToastType
}

public enum ToastType: Equatable, Sendable {
    case error
}
