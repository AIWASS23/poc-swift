//
//  Environment.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import Foundation
import SwiftData
import SwiftUI

struct ChallengesContainer: EnvironmentKey {
    static let defaultValue: ModelContainer = try! .init()
}

extension EnvironmentValues {
    var challengesContainer: ModelContainer {
        get { self[ChallengesContainer.self] }
        set { self[ChallengesContainer.self] = newValue }
    }
}

extension Scene {
    func challengesContainer(_ container: ModelContainer) -> some Scene {
        environment(\.challengesContainer, container)
    }
}

extension View {
    @MainActor func challengesContainer(_ container: ModelContainer) -> some View {
        environment(\.challengesContainer, container)
    }
}
