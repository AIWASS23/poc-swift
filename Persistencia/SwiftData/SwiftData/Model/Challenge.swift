//
//  Challenge.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import Foundation
import SwiftData

@Model
class Challenge3: Identifiable {
    let id: UUID
    var name: String
    var rating: Rating?
    
    init(id: UUID = UUID(), name: String, rating: Rating? = nil) {
        self.id = id
        self.name = name
        self.rating = rating
    }
    
    init(from: Challenge3) {
        self.id = from.id
        self.name = from.name
        self.rating = from.rating
    }
}

@Model
final class Challenge2: Identifiable {
    let id: UUID
    var name: String
    var rating: Rating?
    var createDate: Date = Date.now
    var updateDate: Date = Date.now

    init(
        id: UUID = UUID(),
        name: String,
        rating: Rating? = nil,
        createDate: Date = Date.now,
        updateDate: Date = Date.now
    ) {
        self.id = id
        self.name = name
        self.rating = rating
        self.createDate = createDate
        self.updateDate = updateDate
    }
    
    init(from: Challenge2) {
        self.id = from.id
        self.name = from.name
        self.rating = from.rating
    }
    
    static var all: FetchDescriptor<Challenge2> {
        let find = FetchDescriptor(sortBy: [SortDescriptor(\Challenge2.updateDate, order: .reverse)])
        return find
    }

    static func delete(_ challenge: Challenge2) {
        if let context = challenge.modelContext {
            context.delete(challenge)
        }
    }

    func update(name: String? = nil, rating: Rating? = nil, updateDate: Date = Date.now) {
        if let newName = name {
            self.name = newName
        }
        if let newRating = rating {
            self.rating = newRating
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

