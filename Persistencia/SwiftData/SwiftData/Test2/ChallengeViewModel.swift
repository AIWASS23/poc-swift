////
////  ChallengeViewModel.swift
////  TestSwiftData
////
////  Created by marcelodearaujo on 30/08/24.
////
//
//import Foundation
//import SwiftUI
//import SwiftData
//
//@MainActor
//class CreateChallengesViewModel: ObservableObject {
//    @Published var challenges: [Challenge2] = []
//    private var modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        fetchChallenges()
//    }
//    
//    func fetchChallenges() {
//        let fetchDescriptor = FetchDescriptor<Challenge2>(sortBy: \.name)
//        do {
//            challenges = try modelContext.fetch(fetchDescriptor)
//        } catch {
//            print("Failed to fetch challenges: \(error.localizedDescription)")
//        }
//    }
//    
//    func addChallenge() {
//        var rating: Rating? = nil
//        if Bool.random() {
//            rating = Rating.allCases.randomElement()
//        }
//        let challenge = Challenge2(name: "Challenge #\(challenges.count)", rating: rating)
//        modelContext.insert(challenge)
//        saveContext()
//        fetchChallenges()
//    }
//    
//    func deleteChallenge(_ challenge: Challenge2) {
//        modelContext.delete(challenge)
//        saveContext()
//        fetchChallenges()
//    }
//    
//    private func saveContext() {
//        do {
//            try modelContext.save()
//        } catch {
//            print("Failed to save context: \(error.localizedDescription)")
//        }
//    }
//}
