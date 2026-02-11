//
//  TCAMoviesApp.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct MovieApp: App {
    var body: some Scene {
        WindowGroup {
            MovieFeature.View(
                store: Store(initialState: MovieFeature.State()) {
                    MovieFeature()
                }
            )
        }
    }
}
