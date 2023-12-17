import UIKit

extension UIRectCorner: CaseIterable {
	public static let allCases: [UIRectCorner] = [
		.topLeft, .topRight, .bottomLeft, .bottomRight
	]
}

extension CACornerMask {
	public static var allCorners: CACornerMask {
		[
			.layerMinXMinYCorner,
			.layerMaxXMinYCorner,
			.layerMinXMaxYCorner,
			.layerMaxXMaxYCorner
		]
	}
}

extension UIRectCorner {
	
	var caCornerMask: CACornerMask {
		Self.allCases
			.filter(contains)
			.map(\.rawValue)
			.map(CACornerMask.init)
			.reduce(CACornerMask()) { result, item in
				result.union(item)
			}
	}
}
