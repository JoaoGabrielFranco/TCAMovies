//
//  AppDelegate.swift
//  TCAMovies
//
//  Created by João Gabriel Soares on 19/02/26.
//
import ComposableArchitecture
import SwiftUI
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
