import Foundation

struct Comment: Identifiable, Codable {
    let id: Int32
    let body: String
    let author: User
}

struct CommentDTO: Identifiable, Codable {
    let id: Int32
    let issueID: Int32
    let body: String
}
