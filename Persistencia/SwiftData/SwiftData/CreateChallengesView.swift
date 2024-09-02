//
//  CreateChallengesView.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import SwiftData
import SwiftUI

//struct CreateChallengesView2: View {
//    @Environment(\.modelContext) var modelContext
//    
//    @Query(sort: \Challenge2.name) private var challenges: [Challenge2]
//    
//    var body: some View {
//        NavigationStack {
//            HStack(alignment: .top) {
//                Text("There are \(challenges.count) challenges")
//                    .font(.title)
//                Spacer()
//                Button("Add") {
//                    var rating: Rating? = nil
//                    if Bool.random() {
//                        rating = Rating.allCases.randomElement()
//                    }
//                    let challenge = Challenge2(name: "Challenge #\(challenges.count)", rating: rating)
//                    modelContext.insert(challenge)
//                    do {
//                        try modelContext.save()
//                    } catch {
//                        print("Failed when saving the newly added challenge: \(error.localizedDescription)")
//                    }
//                }
//            }
//            List(challenges) { challenge in
//                VStack(alignment: .leading) {
//                    HStack {
//                        Text(challenge.name)
//                            .font(.title2)
//                        Spacer()
//                        if let rating = challenge.rating {
//                            Text(rating.rawValue)
//                                .font(.title3)
//                        }
//                    }
//                    Text(challenge.id.uuidString)
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                }
//                .swipeActions {
//                    Button("Delete", systemImage: "trash", role: .destructive) {
//                        modelContext.delete(challenge)
//                    }
//                }
//            }
//            .navigationTitle("Challenges")
//        }
//        .padding()
//    }
//}


struct CreateChallengesView3: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Challenge3.name) private var challenges: [Challenge3]
    
    @State private var newChallengeName: String = ""
    @State private var newChallengeRating: Rating? = nil
    @State private var editingChallenge: Challenge3?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    Text("There are \(challenges.count) challenges")
                        .font(.title)
                    Spacer()
                }
                
                Form {
                    Section(header: Text(editingChallenge == nil ? "Add New Challenge" : "Edit Challenge")) {
                        TextField("Challenge Name", text: $newChallengeName)
                        
                        Picker("Rating", selection: $newChallengeRating) {
                            Text("None").tag(Rating?.none)
                            ForEach(Rating.allCases) { rate in
                                Text(rate.rawValue).tag(rate as Rating?)
                            }
                        }
                        
                        Button(action: saveChallenge) {
                            Text(editingChallenge == nil ? "Add Challenge" : "Save Changes")
                        }
                        .disabled(newChallengeName.isEmpty)
                    }
                    
                    if editingChallenge != nil {
                        Button(action: deleteChallenge) {
                            Text("Delete Challenge")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                
                List(challenges) { challenge in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(challenge.name)
                                .font(.title2)
                            if let rating = challenge.rating {
                                Text(rating.rawValue)
                                    .font(.title3)
                            }
                        }
                        Spacer()
                        Button(action: {
                            self.editChallenge(challenge)
                        }) {
                            Text("Edit")
                        }
                    }
                }
            }
            .navigationTitle("Challenges")
        }
    }
    
    private func saveChallenge() {
        if let editingChallenge = editingChallenge {
            editingChallenge.name = newChallengeName
            editingChallenge.rating = newChallengeRating
        } else {
            let newChallenge = Challenge3(name: newChallengeName, rating: newChallengeRating)
            modelContext.insert(newChallenge)
        }
        
        do {
            try modelContext.save()
            resetForm()
        } catch {
            print("Failed to save challenge: \(error.localizedDescription)")
        }
    }
    
    private func deleteChallenge() {
        if let editingChallenge = editingChallenge {
            modelContext.delete(editingChallenge)
            do {
                try modelContext.save()
                resetForm()
            } catch {
                print("Failed to delete challenge: \(error.localizedDescription)")
            }
        }
    }
    
    private func editChallenge(_ challenge: Challenge3) {
        newChallengeName = challenge.name
        newChallengeRating = challenge.rating
        editingChallenge = challenge
    }
    
    private func resetForm() {
        newChallengeName = ""
        newChallengeRating = nil
        editingChallenge = nil
    }
}

