import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    
    init(email: String, firstName: String, lastName: String) {
        self.id = String()
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case email
        case firstName
        case lastName
    }
}

extension User {
    var initials: String {
        let index = firstName.index(firstName.startIndex, offsetBy: 1)
        let result = firstName.prefix(upTo: index) + lastName.prefix(upTo: index)
        return result.uppercased()
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

class InviteRequest: Codable {
    var email: String
    var projectID: Int32
    
    required init(email: String = "", project: any ProjectEntity) {
        self.email = email
        self.projectID = project.id
    }
}

struct UserRemovalDTO: Codable {
    let userUUID: String
    let projectID: Int32
    
    init(user: User, project: ProjectDTO) {
        self.userUUID = user.id
        self.projectID = project.id
    }
}

struct UserRole: Identifiable, Codable {
    let id: String
    let name: String
}

enum UserScope: String, CaseIterable {
    case sm = "sm"
    case dev = "client_user"
    case none
}
