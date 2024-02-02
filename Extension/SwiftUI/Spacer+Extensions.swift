import Foundation
import SwiftUI

extension Spacer {
    static func between(
        _ range: ClosedRange<CGFloat>,
        ideal: CGFloat? = nil,
        limitVertically: Bool = true,
        limitHorizontally: Bool = true
    ) -> some View {
        Spacer(minLength: range.lowerBound)
            .frame(
                idealWidth: limitHorizontally ? ideal : nil,
                maxWidth: limitHorizontally ? range.upperBound: nil,
                idealHeight: limitVertically ? ideal : nil,
                maxHeight: limitVertically ? range.upperBound : nil
            )
    }

    static func exactWidth(_ value: CGFloat) -> some View {
        Spacer(minLength: value).frame(width: value, height: 1)
    }

    static func exactHeight(_ value: CGFloat) -> some View {
        Spacer(minLength: value).frame(width: 1, height: value)
    }

    static func multiple(_ multipler: Int, minLength: CGFloat? = nil) -> some View {
        MultipleSpacer(multiplier: multipler, minLength: minLength)
    }
}
