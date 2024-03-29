//
//  XServices.swift
//  X
//
//  Created by Manuel Crovetto on 30/09/2023.
//

import FirebaseFirestore
import Foundation

class Services {
    static let shared = Services()
    private let db = Firestore.firestore()

    func create(Data: Data) async -> Response<(), ()> {
        if let _ = AuthServices.shared.userSession?.uid {
            let document = db.collection("xs").document()
            await setDocumentData(documentReference: document, data: Data)
            return .success(())
        } else {
            return .error("\(self): UserID is nil.")
        }
    }
    
    //now it receives a lastdocument. In the view the first time is fetching data lastDocument will be passed
    // as nil, after the first time the lastDocument will be used to implement the pagination.

    func fetchs(payload: Int, lastDocument: QueryDocumentSnapshot?) async -> Response<DataAndLastDocument, [String]> {
        if let userId = AuthServices.shared.userSession?.uid {
            guard let listOfuserIdsThatCurrentUserFollows = await getListOfFollows(userId: userId) else {
                return .error("List of follows is nil.")
            }
            
            guard let DataAndLastDocument = await getAllXsOfFollows(followsList: listOfuserIdsThatCurrentUserFollows, payload: payload, lastDocument: lastDocument) else {
                return .error("List of Xs is nil.")
            }
            
            return .success(DataAndLastDocument, aditional: listOfuserIdsThatCurrentUserFollows)
        } else {
            return .error("Error in \(self): UserID is nil")
        }
    }
    
    func delete(userId: String, Id: String) async -> Response<(), ()>{
        do {
            if userId == AuthServices.shared.userSession?.uid {
                try await db.collection("xs")
                    .document(xId)
                    .delete()
                return .success(())
            } else {
                print("Error in \(self): X requested to delete does not belongs to current user.")
                return .error("X requested to delete does not belongs to current user.")
            }
            
           
        } catch {
            print("Error in \(self): X could not been deleted.")
            return .error(error.localizedDescription)
        }
    }

    private func setDocumentData(documentReference: DocumentReference, data: Data) async {
        do {
            try documentReference.setData(from: data)
        } catch {
            print("\(self): error during creation of X document in Firebase. Stacktrace: \(error)")
        }
    }
    
    private func mappedDocuments(documents: [QueryDocumentSnapshot]) -> [Data]? {
        do {
            return try documents.map { document in
                try document.data(as: Data.self)
            }
        } catch {
            print("Error in \(self): Error during mapping documents to XData types. Stacktrace: \(error)")
            return nil
        }
    }
    
    private func getListOfFollows(userId: String) async -> [String]? {
        do {
            var followsList = try await db.collection("users").document(userId).collection("follows").getDocuments().documents.map { document in
                document.documentID
            }
            followsList.append(userId)
            return followsList
        } catch {
            print("Error in \(self): error during getting list of follows.")
            return nil
        }
    }
    
    private func getAllXsOfFollows(followsList: [String], payload: Int, lastDocument: QueryDocumentSnapshot?) async -> DataAndLastDocument? {
        do {
            var query: Query = db.collection("xs")
            query = query.whereField("userId", in: followsList)
            query = query.limit(to: payload)
            query = query.order(by: "date", descending: true)
            if let lastDocument = lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            let xsQuerySnapshot = try await query.getDocuments()
            let lastDocument = xsQuerySnapshot.documents.last
            let xsList = try xsQuerySnapshot.documents.map { document in
                try document.data(as: Data.self)
            }
            let xDataAndLastDocument = DataAndLastDocument(lastDocument: lastDocument, xData: xsList)
            return xDataAndLastDocument
        } catch {
            print("Error in \(self): error during fetching Xs from follows list.")
            return nil
        }
    }
    
    func updateNicknameOnXs(newNickname: String) async {
        do {
            guard let uid = AuthServices.shared.userSession?.uid else {
                print("Error in \(self): UserId is nil.")
                return
            }
            try await db.collection("xs").whereField("userId", isEqualTo: uid).getDocuments().documents.forEach { document in
                document.reference.setData(["nickName" : newNickname], merge: true)
            }
        } catch {
            print("Error in \(self): updating nickname on Xs failed.")
        }
    }
    
    func updateUrlImageOnXs(newUrl: String) async {
        do {
            guard let uid = AuthServices.shared.userSession?.uid else {
                print("Error in \(self): UserId is nil.")
                return
            }
            try await db.collection("xs").whereField("userId", isEqualTo: uid).getDocuments().documents.forEach { document in
                document.reference.setData(["imageUrl" : newUrl], merge: true)
            }
        } catch {
            print("Error in \(self): Updating url in Xs failed.")
        }
    }
}
