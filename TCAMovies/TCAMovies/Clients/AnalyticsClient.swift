//
//  AnalyticsClient.swift
//  TCAMovies
//
//  Created by dti on 11/02/26.
//

import ComposableArchitecture
import FirebaseAnalytics
import FirebaseCrashlytics

struct AnalyticsClient: Sendable {
    // MARK: - Properties
    var logEvent: @Sendable (_ event: AnalyticsEvent) async -> Void
    
    var log: @Sendable (_ message: String) async -> Void
    var record: @Sendable (_ error: Error) async -> Void
    var setUserID: @Sendable (_ id: String) async -> Void
}
// MARK: - Dependency
extension DependencyValues {
    var analyticsClient: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}

extension AnalyticsClient: DependencyKey {
    
    static let liveValue = AnalyticsClient(
        logEvent: { event in
            let firebaseParams = event.parameters
            
            Analytics.logEvent(event.name, parameters: firebaseParams)
        },
        log: { message in
            Crashlytics.crashlytics().log(message)
        },
        record: { error in
            Crashlytics.crashlytics().record(error: error)
        },
        setUserID: { id in
            Crashlytics.crashlytics().setUserID(id)
            Analytics.setUserID(id)
        }
    )
    
    static let testValue = AnalyticsClient(
        logEvent: { event in
            
            print("[Analytics]: \(event.name) - Params: \(String(describing: event.parameters))")
        },
        log: { print("[Log]: \($0)") },
        record: { print("[Error]: \($0)") },
        setUserID: { print("[UserID]: \($0)") }
    )
    
    static let previewValue = AnalyticsClient(
        logEvent: { _ in },
        log: { _ in },
        record: { _ in },
        setUserID: { _ in }
    )
}

