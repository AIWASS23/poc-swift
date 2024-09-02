//
//  ChallengeRowViewModel.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 30/08/24.
//

//import Foundation
//import SwiftData
//
//@Observable
//class ChallengeRowViewModel: ObservableObject {
//    
//    var challenge: Challenge2
//    @Published var records: [Completion2] = []
//    
//    private let context: ModelContext
//    
//    init(challenge: Challenge2, /* record: [Completion2], */ context: ModelContext) {
//        self.challenge = challenge
//        //self.records = record
//        self.context = context
//        fetchCompletionRecords()
//    }
//    
//    func fetchCompletionRecords() {
//        let challengeID = challenge.id
//        let predicate = #Predicate<Completion2> { record in
//            record.challengeID == challengeID
//        }
//        
//        let fetchDescriptor = FetchDescriptor<Completion2>(predicate: predicate)
//        
//        do {
//            records = try context.fetch(fetchDescriptor)
//        } catch {
//            print("Failed to fetch completion records: \(error.localizedDescription)")
//        }
//    }
//    
//    func completeChallenge() {
//        let record = Completion2(challengeID: challenge.id)
//        context.insert(record)
//        saveContext()
//        fetchCompletionRecords()
//    }
//    
//    func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save context: \(error.localizedDescription)")
//        }
//    }
//    
//    func deleteCompletion(_ completion: Completion2) {
//        Completion2.delete(completion)
//        saveContext()
//        fetchCompletionRecords()
//    }
//}
