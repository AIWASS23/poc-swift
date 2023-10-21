import Foundation

struct ChangePermissionRequest: Codable {
    let projectID: Int32
    let userUUID: String
    let roleName: String
}
