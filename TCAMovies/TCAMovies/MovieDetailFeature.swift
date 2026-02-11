//
//  MovieDetailFeature.swift
//  TCAMovies
//
//  Created by dti on 09/02/26.
//

import Foundation
import ComposableArchitecture

@Reducer
// TODO: Rename to MovieDetailsFeature
struct MovieDetailFeature {

    // MARK: - State
    @ObservableState
    struct State: Equatable {

        // MARK: - Properties
        // TODO: Prefira movieID para manter padrao do projeto
        let movieId: Int
        var movieDetail: MovieDetail?

        // TODO: `isLoading` e `errorMessage` não podem coexistir. Ou seja, `isLoading` nao pode ser true enquanto o `errorMessage` != nil. Pesquise no projeto o enum Status e veja seu uso para aplicar aqui
        /*
         public enum Status: Equatable, Sendable {
             case `default`
             case loading
             case submitted
             case toast(ToastConfiguration?)
         }
         */
        var isLoading = false
        var errorMessage: String?
    }

    // MARK: - Action
    // TODO: Para você fazer de uma forma mais limpa. Pode criar um erro customizado como MovieDetail.Error, e ele ser Equatable
    enum Action: Equatable {
        case fetchMovieDetails
        // TODO: use handleMovieDetailsResponse(Result<MovieDetail, Error>). No projeto, usamos essa nomenclatura, pode pesquisar que vera varios exemplos
        case movieDetailsResponse(Result<MovieDetail, Error>)

        // TODO: Ao criar o erro customizado, pode remover aqui
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

    // MARK: - Properties
    @Dependency(\.movieClient) var movieClient

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMovieDetails:
                state.isLoading = true
                state.errorMessage = nil

                // TODO: Faz sentido essa escrita para voce? E a que usamos no projeto
                /*
                 return .run { [movieId = state.movieId] send in
                     await send(.handleMovieDetailsResponse(Result {
                         try await movieClient.fetchMovieDetails(movieId)
                     }))
                 }
                 */
                return .run { [movieId = state.movieId] send in
                    do {
                        let movieDetail = try await movieClient.fetchMovieDetails(movieId)
                        await send(.movieDetailsResponse(.success(movieDetail)))
                    } catch {
                        await send(.movieDetailsResponse(.failure(error)))
                    }
                }

            // TODO: Experimente usar um unico case ja abrangindo o succes e a failure para melhorar a leitrura e evitar possiveis repeticoes, como `state.isLoading = false`
                /*
                 case let .handleMovieDetailsResponse(result):
                   state.isLoading = false
                   switch result {
                   case let .success(movieDetail):
                     // handle success
                   case let .failure(error):
                     // handle error
                 */

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
