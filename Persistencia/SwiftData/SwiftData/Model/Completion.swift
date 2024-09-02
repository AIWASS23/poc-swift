//
//  CompletionRecord.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import Foundation
import SwiftData

@Model
final class Completion2 {
    let id: UUID
    var challengeID: UUID
    var createDate: Date
    var updateDate: Date
    
    
    init(
        id: UUID = UUID(),
        challengeID: UUID,
        createDate: Date = Date.now,
        updateDate: Date = Date.now
    ) {
        self.id = id
        self.challengeID = challengeID
        self.createDate = createDate
        self.updateDate =  updateDate
    }
    
    static var all: FetchDescriptor<Completion2> {
        let find = FetchDescriptor(sortBy: [SortDescriptor(\Completion2.updateDate, order: .reverse)])
        return find
    }
    
    static func delete(_ completion: Completion2) {
        if let context = completion.modelContext {
            context.delete(completion)
        }
    }
    
    func update(challengeID: UUID? = nil, updateDate: Date = Date.now) {
        if let newChallengeID = challengeID {
            self.challengeID = newChallengeID
        }
        self.updateDate = updateDate
        saveContext()
    }
    
    private func saveContext() {
        do {
            try modelContext?.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

@Model
class Completion3 {
    let id: UUID
    let challengeID: UUID
    var date: Date
    
    init(id: UUID = UUID(), challengeID: UUID, date: Date = .now) {
        self.id = id
        self.challengeID = challengeID
        self.date = date
    }
}

