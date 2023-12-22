import Foundation

extension Array {
    /// Accesses the element at the specified position, if in bounds.
    ///
    ///     let array = [10, 20, 30, 40]
    ///     array[safe: 3] // Optional(40)
    ///     array[safe: 4] // nil
    ///
    @inlinable subscript(safe index: Int) -> Element? {
        guard index >= startIndex, index < endIndex else { return nil }
        return self[index]
    }
}

extension Array {
    /// Split array elements into chunks of a given size.
    ///
    ///     let array = [1, 2, 3, 4, 5, 6, 7, 8]
    ///     array.chunked(into: 2) // [[1, 2], [3, 4], [5, 6], [7, 8]]
    ///     array.chunked(into: 3) // [[1, 2, 3], [4, 5, 6], [7, 8]]
    ///
    /// - Parameter into: chunk size.
    @available(*, deprecated, message: "Use `chunks(ofCount:)` from swift-algorithms")
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
