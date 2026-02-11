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

    // MARK: - State
    @ObservableState
    struct State: Equatable {

        // MARK: - Properties
        var movies: [Movie] = []

        // TODO: Siga mesmo padrao recomendado para MovieDetailFeature
        var isLoading = false
        var errorMessage: String?

        @Presents var movieDetail: MovieDetailFeature.State?
        var searchText = ""

        // MARK: - Interface
        var filteredMovies: [Movie] {
            if searchText.isEmpty{
                return movies
            } else {
                // TODO: Tente abrangir mais do que so o titulo na busca. Inclua descricao, generos e, por exemplo. Mantendo sempre case insensitive
                return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }

    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case fetchMovies
        case binding(BindingAction<State>)
        // TODO: use handleMoviesResponse(Result<MovieDetail, Error>). No projeto, usamos essa nomenclatura, pode pesquisar que vera varios exemplos
        case moviesResponse(Result<[Movie], Error>)
        case movieTapped(Movie)
        case movieDetail(PresentationAction<MovieDetailFeature.Action>)

        // TODO: Com a alteracao no MovieDetailFeature, possivelmente conseguiremos remover essa funcao verbosa aqui tambem
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

    // MARK: - Properties
    @Dependency(\.movieClient) var movieClient

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .fetchMovies:
                state.isLoading = true
                state.errorMessage = nil

                // TODO: Siga mesmo padrao recomendado para MovieDetailFeature
                return .run { send in
                    do {
                        let movies = try await movieClient.fetchPopularMovies()
                        await send(.moviesResponse(.success(movies)))
                    } catch {
                        await send(.moviesResponse(.failure(error)))
                    }
                }

            // TODO: Siga mesmo padrao recomendado para MovieDetailFeature
            case let .moviesResponse(.success(movies)):
                state.isLoading = false
                state.movies = movies
                return .none

            // TODO: Siga mesmo padrao recomendado para MovieDetailFeature
            case let .moviesResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none

            case let .movieTapped(movie):
                // TODO: state.movieDetail = .init(movieId: movie.id) tambem e uma sintaxe valida (so por curiosidade mesmo, nao precisa mudar)
                state.movieDetail = MovieDetailFeature.State(movieId: movie.id)
                return .none

            case .movieDetail:
                return .none
            }
        }
        // TODO: Importante entender o que esta acontecendo aqui
        .ifLet(\.$movieDetail, action: \.movieDetail) {
            MovieDetailFeature()
        }
    }
}
