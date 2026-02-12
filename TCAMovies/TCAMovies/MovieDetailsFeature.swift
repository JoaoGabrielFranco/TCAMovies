//
//  MovieDetailFeature.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieDetailsFeature {
    @ObservableState
    struct State: Equatable {
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

    
    enum Action: Equatable {
        case fetchMovieDetails
        case handleMovieDetailsResponse(Result<MovieDetail, MovieDetail.Error>)
        case onAppear
    }
    @Dependency(\.analytics) var analytics
    @Dependency(\.movieClient) var movieClient
    
    var body: some Reducer<State, Action> {
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
enum Status: Equatable, Sendable {
    case `default`
    case loading
    case submitted
    case toast(ToastConfiguration?)
}
struct ToastConfiguration: Equatable, Sendable {
    let title: String
    let message: String
    let type: ToastType // error, success, etc
}

enum ToastType: Equatable, Sendable {
    case error
}
