//
//  AnalyticsClient.swift
//  TCAMovies
//
//  Created by dti on 11/02/26.
//

import ComposableArchitecture
import FirebaseAnalytics


struct AnalyticsClient {
    var logEvent: (_ name: String, _ parameters: [String: Any]?) -> Void
}

extension DependencyValues {
    var analytics: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}


extension AnalyticsClient: DependencyKey {
    static let liveValue = AnalyticsClient(
        logEvent: { name, params in
            Analytics.logEvent(name, parameters: params)
        }
    )
    static let testValue = AnalyticsClient(
        logEvent: { name, params in
            print("Analytics [TEST]: \(name) - \(params ?? [:])")
        }
    )
}
