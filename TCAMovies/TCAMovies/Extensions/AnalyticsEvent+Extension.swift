//
//  Analytics+Movies.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 13/02/26.
//
import FirebaseAnalytics
// MARK: - Extension
extension AnalyticsEvent {
    static var viewPopularMovies: Self {
        return AnalyticsEvent(
            name: "screen_view",
            parameters: [
                "screen_name": "PopularMovies",
                "screen_class": "MovieFeatureView"
            ]
        )
    }
    
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
        
        let itemsArray = movies.prefix(20).map { movie -> [String: Any] in
            [
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





