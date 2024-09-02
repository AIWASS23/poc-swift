//
//  ListCompletionsView.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import SwiftData
import SwiftUI

struct ListCompletionsView: View {
    @Environment(\.modelContext) var completionRecordContext
    @Environment(\.challengesContainer) var challengesContainer: ModelContainer
    
    @Query(sort: \Completion3.date) private var records: [Completion3]
    
    @MainActor
    func challengeWith(id: UUID) -> Challenge3? {
        let predicate = #Predicate<Challenge3> { challenge in
            challenge.id == id
        }
        let fetchDescriptor = FetchDescriptor(predicate: predicate)
        do {
            let challenges = try challengesContainer.mainContext.fetch(fetchDescriptor)
            return challenges.first
        } catch {
            print("Failed to find challenge \(id): \(error.localizedDescription)")
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            List(records) { record in
                HStack {
                    Text("\(challengeWith(id: record.challengeID)?.name ?? "Unknown challenge") completed:")
                    
                    Spacer()
                    
                    Text(record.date, style: .date)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        completionRecordContext.delete(record)
                    }
                }
            }
            .navigationTitle("Completions")
        }
    }
}
