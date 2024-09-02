//
//  ListChallengeView.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import SwiftData
import SwiftUI

struct ListChallengeView: View {
    @Environment(\.modelContext) var completionRecordContext
    @Environment(\.challengesContainer) var challengesContainer: ModelContainer
    
    @MainActor
    func getChallenges() -> [Challenge3] {
        let fd = FetchDescriptor<Challenge3>(sortBy: [SortDescriptor(\.name)])
        do {
            let challenges = try challengesContainer.mainContext.fetch(fd)
            return challenges
        } catch {
            print("Failed to fetch challenges: \(error.localizedDescription)")
        }
        return []
    }
    
    var body: some View {
        NavigationStack {
            List(getChallenges()) { challenge in
                ChallengeRowView3(challenge: challenge)
            }
            .navigationTitle("Challenges")
        }
    }
}
