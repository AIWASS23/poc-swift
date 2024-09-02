//
//  MainTabView.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import SwiftData
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ListChallengeView()
                .tabItem {
                    Label("Challenges", systemImage: "figure.walk.motion")
                }
            
            ListCompletionsView()
                .tabItem {
                    Label("Completions", systemImage: "checkmark.circle")
                }
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Completion3.self, Challenge3.self, configurations: configuration)
    
    return MainTabView()
        .modelContainer(container)
        .challengesContainer(container)
}
