import Foundation

extension Auth {
    var isValid: Bool {
        let currentDate = Date()
        return expiresAt > currentDate
    }
}

