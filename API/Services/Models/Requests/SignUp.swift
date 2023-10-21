import Foundation

struct SignUpRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let isScrumMaster: Bool
    
    init(firstName: String, lastName: String, email: String, password: String, isScrumMaster: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.isScrumMaster = isScrumMaster
    }
}

struct SignUpResponse: Codable {
    let result: String
    let success: Bool
}
