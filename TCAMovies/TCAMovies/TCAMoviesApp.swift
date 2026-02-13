//
//  TCAMoviesApp.swift
//  TCAMovies
//
//  Created by dti on 05/02/26.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore
import FirebaseCrashlytics

// MARK: - Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Crashlytics.crashlytics()
        print("Firebase Configurado!")
        return true
    }
}
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
