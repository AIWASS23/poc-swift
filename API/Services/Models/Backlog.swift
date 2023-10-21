import Foundation

struct Backlog: Codable {
    let id: Int32
    let issues: Array<Issue>?
}
