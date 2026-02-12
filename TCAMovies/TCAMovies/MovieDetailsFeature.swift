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
    @ObservableState
    public struct State: Equatable {
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
    
    
    public enum Action: Equatable {
        case fetchMovieDetails
        case handleMovieDetailsResponse(Result<MovieDetail, MovieDetail.Error>)
        case onAppear
    }
    @Dependency(\.analytics) var analytics
    @Dependency(\.movieClient) var movieClient
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .run { [title = state.movieTitle, id = state.movieID] send in
                    await analytics.logEvent("view_movie", [
                        "screen_name": "Movies_Detail",
                        "movie_title": title,
                        "movie_id": id
                    ])
                    await send(.fetchMovieDetails)
                }
                
            case .fetchMovieDetails:
                state.status = .loading
                
                return .run { [movieID = state.movieID] send in
                    do {
                        let detail = try await movieClient.fetchMovieDetails(movieID)
                        
                        // Sucesso: Passamos o detalhe
                        await send(.handleMovieDetailsResponse(.success(detail)))
                        
                    } catch {
                        // Falha: Convertemos o erro genérico para MovieDetail.Error
                        let customError = MovieDetail.Error(error)
                        await send(.handleMovieDetailsResponse(.failure(customError)))
                    }
                }
                
                // Tratamento unificado da resposta
            case let .handleMovieDetailsResponse(result):
                switch result {
                case let .success(detail):
                    state.status = .default
                    state.movieDetail = detail
                    
                case let .failure(error):
                    // Extraímos a mensagem do nosso erro customizado
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
public enum Status: Equatable, Sendable {
    case `default`
    case loading
    case submitted
    case toast(ToastConfiguration?)
}
public struct ToastConfiguration: Equatable, Sendable {
    public let title: String
    public let message: String
    public let type: ToastType // error, success, etc
}

public enum ToastType: Equatable, Sendable {
    case error
}
