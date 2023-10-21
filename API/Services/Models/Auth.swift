import Foundation

struct Auth: Codable {
    let token: String
    let expiresAt: Date
    
    init(token: String, expiresIn: Int32) {
        self.token = token
        let timeInterval = Double(expiresIn)
        self.expiresAt = Date().addingTimeInterval(timeInterval)
    }
}


