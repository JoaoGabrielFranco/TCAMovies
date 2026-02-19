//
//  TCAMoviesApp.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 05/02/26.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore
import FirebaseCrashlytics


// MARK: - App
@main
struct MovieApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
