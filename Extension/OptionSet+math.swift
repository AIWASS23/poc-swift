import Foundation

extension OptionSet {
	@inlinable
	static func + (lhs: Self, rhs: Self) -> Self {
		lhs.union(rhs)
	}
}
