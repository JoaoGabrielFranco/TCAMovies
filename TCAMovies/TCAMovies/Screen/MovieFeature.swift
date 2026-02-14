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
        var status: Status = .default

        public var isLoading: Bool {
            return status == .loading
        }
        public var errorMessage: String? {
            if case let .toast(config) = status {
                return config?.message
            }
            return nil
        }
        
        @Presents var movieDetail: MovieDetailsFeature.State?
        var searchText = ""

        var filteredMovies: [Movie] {
            if searchText.isEmpty{
                return movies
            } else {
                return movies.filter { movie in
                    let titleMatch = movie.title.localizedCaseInsensitiveContains(searchText)
                    let overviewMatch = movie.overview?.localizedCaseInsensitiveContains(searchText) ?? false
                    return titleMatch || overviewMatch
                }
            }
        }
    }

    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case fetchMovies
        case binding(BindingAction<State>)
        case handleMoviesResponse(Result<[Movie], Movie.Error>)
        case movieTapped(Movie)
        case movieDetail(PresentationAction<MovieDetailsFeature.Action>)
        case onAppear
        case fatalErrorTapped
    }

    // MARK: - Properties
    @Dependency(\.analyticsClient) var analytics
    @Dependency(\.movieClient) var movieClient

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return .run { send in
                    await analytics.logEvent(.viewPopularMovies)
                    await send(.fetchMovies)
                }

            case .fetchMovies:
                state.status = .loading

                // TODO: Mesmmo comentario do MovieDetailFeature
                return .run { send in
                    do {
                        let movies = try await movieClient.fetchPopularMovies()
                        await send(.handleMoviesResponse(.success(movies)))
                    } catch {
                        let customError = Movie.Error(error)
                        await send(.handleMoviesResponse(.failure(customError)))
                    }
                }
                
            case let .handleMoviesResponse(result):
                switch result {
                case let .success(movies):
                    state.status = .default
                    state.movies = movies
                    return .run { _ in
                        await analytics.logEvent(.moviesLoaded(movies))
                    }

                case let .failure(error):
                    // TODO: Mesmmo comentario do MovieDetailFeature

                    let message: String
                    switch error {
                    case let .generic(msg): message = msg
                    }
                    
                    state.status = .toast(ToastConfiguration(
                        title: "Error",
                        message: message,
                        type: .error
                    ))
                }
                return .none
                
            case .fatalErrorTapped:
                fatalError("crash!!")
            case let .movieTapped(movie):
                state.movieDetail = .init(movieID: movie.id, movieTitle: movie.title)
                return .run { _ in
                    await analytics.logEvent(.clickMovie(movie))
                }

                // TODO: Considere usar o default nesses casos para evitar repetir .movieDetail e .binding retornando none
            case .movieDetail:
                return .none
            }
        }
        .ifLet(\.$movieDetail, action: \.movieDetail) {
            MovieDetailsFeature()
        }
    }
}
