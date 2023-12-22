import Foundation

extension Comparable {
    /// Returns the value clamped to the given limiting range.
    ///
    ///     20.clamped(to: 10...30) // 20
    ///     20.clamped(to: 25...30) // 25
    ///     20.clamped(to: 10...15) // 15
    ///
    /// - Parameter range: The range to clamp the value to.
    /// - Returns: A new value clamped to the bounds of `range`.
    func clamped(to range: ClosedRange<Self>) -> Self {
        max(min(self, range.upperBound), range.lowerBound)
    }
}
