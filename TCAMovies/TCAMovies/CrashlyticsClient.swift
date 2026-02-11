//
//  CrashlyticsClient.swift
//  TCAMovies
//
//  Created by dti on 11/02/26.
//

import ComposableArchitecture
import FirebaseCrashlytics

// 1. A Interface
struct CrashlyticsClient {
var log: (_ message: String) -> Void
var record: (_ error: Error) -> Void
var setUserID: (_ id: String) -> Void
}

// 2. Registro da Dependência
extension DependencyValues {
var crashlytics: CrashlyticsClient {
    get { self[CrashlyticsClient.self] }
    set { self[CrashlyticsClient.self] = newValue }
}
}

// 3. Implementação Live e Teste
extension CrashlyticsClient: DependencyKey {
static let liveValue = CrashlyticsClient(
    log: { message in
        Crashlytics.crashlytics().log(message)
    },
    record: { error in
        Crashlytics.crashlytics().record(error: error)
    },
    setUserID: { id in
        Crashlytics.crashlytics().setUserID(id)
    }
)

static let testValue = CrashlyticsClient(
    log: { print("[Crashlytics Log]: \($0)") },
    record: { print("[Crashlytics Error]: \($0)") },
    setUserID: { print("[Crashlytics User]: \($0)") }
)
}
