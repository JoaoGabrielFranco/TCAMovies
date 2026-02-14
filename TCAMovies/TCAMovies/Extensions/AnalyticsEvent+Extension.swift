//
//  Analytics+Movies.swift
//  TCAMovies
//
//  Created by dti on 13/02/26.
//

// TODO: Nos nomes dos arquivos o + ja significa extension. Talvez colocar AnalyticsEvent+Utilities.swift ou AnalyticsEvent+Movies.swift seja mais claro?

// TODO: Import ta sendo utilizado?
import FirebaseAnalytics

// MARK: - Extension
extension AnalyticsEvent {
    static var viewPopularMovies: Self {

        // TODO: Pesquise sobre implict return
        // TODO: Voce pode colocar .init() ao inves de AnalyticsEvent()
        // TODO: veja se é possível evitar a necessidade de repetir os parâmetros "screen_name" e "screen_class" em cada evento relacionado à tela de filmes populares. Procure no projeto `Analytics.Events+Types.swift`
        return AnalyticsEvent(
            name: "screen_view",
            parameters: [
                "screen_name": "PopularMovies",
                "screen_class": "MovieFeatureView"
            ]
        )
    }

    // TODO: Evite colocar parametros com _, as vezes, clickMovie(for movie: Movie)?
    static func clickMovie(_ movie: Movie) -> Self {
        return AnalyticsEvent(
            name: "click_movie",
            parameters: [
                "movie_id": movie.id,
                "movie_title": movie.title,
                "screen_name": "PopularMovies",
                "screen_class": "MovieFeatureView"
            ]
        )
    }

    static func moviesLoaded(_ movies: [Movie]) -> Self {
        // TODO: Qual o motivo de enviar apenas os 20 primeiros filmes?
        let itemsArray = movies.prefix(20).map { movie -> [String: Any] in
            [
                // TODO: Qual o motivo de enviar apenas os 50 primeiros caracteres?
                AnalyticsParameterItemID: String(movie.id),
                AnalyticsParameterItemName: String(movie.title.prefix(50))
            ]
        }
        
        return AnalyticsEvent(
            name: AnalyticsEventViewItemList,
            parameters: [
                AnalyticsParameterItemListName: "Popular Movies",
                AnalyticsParameterItems: itemsArray
            ]
        )
    }

    static func viewMovieDetail(id: Int, title: String) -> Self {
        return AnalyticsEvent(
            name: "movie_view",
            parameters: [
                "screen_name": "MovieDetailView",
                "screen_class": "MovieDetailsFeature",
                "movie_id": id,
                "movie_title": title
            ]
        )
    }
}

// TODO: Atencao aos espacos em branco



