import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Data: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let date: Timestamp
    let body: String
    let nickName: String
    let imageUrl: String
    let username: String
    let reposts: [String]
    let comments: [Data]
    let likes: [String]

}
