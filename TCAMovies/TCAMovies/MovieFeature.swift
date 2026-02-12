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
        var status: Status = .default
        
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
    
    enum Action: BindableAction, Equatable {
        case fetchMovies
        case binding(BindingAction<State>)
        case handleMoviesResponse(Result<[Movie], Movie.Error>)
        case movieTapped(Movie)
        case movieDetail(PresentationAction<MovieDetailsFeature.Action>)
        case onAppear
        case fatalErrorTapped
    }
    
    @Dependency(\.analytics) var analytics
    @Dependency(\.crashlytics) var crashlytics
    @Dependency(\.movieClient) var movieClient
    
    var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return .run { send in
                    await analytics.logEvent("screen_view", [
                        "screen_name": "PopularMovies",
                        "screen_class": "MovieFeatureView"
                    ])
                    await send(.fetchMovies)
                }
            case .fetchMovies:
                // Mudança de estado limpa
                state.status = .loading
                
                return .run { send in
                    do {
                        let movies = try await movieClient.fetchPopularMovies()
                        await send(.handleMoviesResponse(.success(movies)))
                    } catch {
                        // Conversão para o erro customizado
                        let customError = Movie.Error(error)
                        await send(.handleMoviesResponse(.failure(customError)))
                    }
                }
                
                // Caso unificado de Handle
            case let .handleMoviesResponse(result):
                switch result {
                case let .success(movies):
                    state.status = .default
                    state.movies = movies
                    
                case let .failure(error):
                    // Extração da mensagem do erro customizado
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
                analytics.logEvent("click_movie", [
                    "screen_name": "PopularMovies",
                    "screen_class": "MovieFeatureView",
                    "movie_title": movie.title
                ])
                state.movieDetail = .init(movieID: movie.id, movieTitle: movie.title)
                
                return .none
            case .movieDetail:
                return .none
            }
        }
        .ifLet(\.$movieDetail, action: \.movieDetail) {
            MovieDetailsFeature()
        }
    }
}
