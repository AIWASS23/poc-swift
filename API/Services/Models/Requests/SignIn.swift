import Foundation

struct SignInRequest: Codable {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

struct SignInResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    let expiresIn: Int32
    let refreshExpiresIn: Int32
    
    let userRoles: Array<UserRole>
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case userRoles
    }
}
