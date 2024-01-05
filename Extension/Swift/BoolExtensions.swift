import Foundation

extension Bool {
    
    var int: Int {
        return self ? 1 : 0
    }

    var string: String {
        return self ? "true" : "false"
    }
}
