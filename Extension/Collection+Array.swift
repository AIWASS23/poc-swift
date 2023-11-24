import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// uso

// if let lion = pets[safe: 3] {
// // Usage
// }