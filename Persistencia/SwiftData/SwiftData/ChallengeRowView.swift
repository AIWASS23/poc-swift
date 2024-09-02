//
//  ChallengeRowView.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import SwiftData
import SwiftUI

//struct ChallengeRowView2: View {
//    
//    @Bindable var challenge: Challenge2
//    @Environment(\.modelContext) var completionRecordContext
//    @Query private var records: [Completion2]
//    
//    @StateObject var vm: ChallengeRowViewModel
//    
//    init(challenge: Challenge2) {
//        self.challenge = challenge
//        
//        let challengeID = challenge.id
//        let predicate = #Predicate<Completion2> { record in
//            record.challengeID == challengeID
//        }
//        
//        self._records = Query(filter: predicate)
//        
//        _vm = StateObject(wrappedValue: ChallengeRowViewModel(challenge: challenge, record: records, context: completionRecordContext))
//        
//        //self.vm = ChallengeRowViewModel(challenge: challenge, record: records, context: completionRecordContext)
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text(challenge.name)
//                    .font(.title2)
//                
//                Spacer()
//                
//                if let record = records.first {
//                    Text(record.createDate, style: .date)
//                } else {
//                    Button(action: {
//                        let record = Completion2(challengeID: challenge.id)
//                        completionRecordContext.insert(record)
//                        do {
//                            try completionRecordContext.save()
//                        } catch {
//                            print("Failed to save completion record: \(error.localizedDescription)")
//                        }
//                    }, label: {
//                        Text("Complete")
//                    })
//                }
//            }
//            Text(challenge.id.uuidString)
//                .font(.caption)
//                .foregroundStyle(.secondary)
//        }
//        
//        .onAppear {
//                    // Ensuring that the view model is initialized correctly
//            vm.fetchCompletionRecords()
//            //vm = ChallengeRowViewModel(challenge: challenge, record: records, context: completionRecordContext)
//        }
//    }
//}


struct ChallengeRowView3: View {
    @Environment(\.modelContext) var completionRecordContext
    
    @Query private var records: [Completion3]
    
    @Bindable var challenge: Challenge3
    
    init(challenge: Challenge3) {
        self.challenge = challenge
        
        let challengeID = challenge.id
        let predicate = #Predicate<Completion3> { record in
            record.challengeID == challengeID
        }
        
        self._records = Query(filter: predicate)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(challenge.name)
                    .font(.title2)
                
                Spacer()
                
                if let record = records.first {
                    Text(record.date, style: .date)
                } else {
                    Button(action: {
                        let record = Completion3(challengeID: challenge.id)
                        completionRecordContext.insert(record)
                        do {
                            try completionRecordContext.save()
                        } catch {
                            print("Failed to save completion record: \(error.localizedDescription)")
                        }
                    }, label: {
                        Text("Complete")
                    })
                }
            }
            Text(challenge.id.uuidString)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
