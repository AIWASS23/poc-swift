import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
	static func == (
		lhs: CLLocationCoordinate2D,
		rhs: CLLocationCoordinate2D
	) -> Bool {
		lhs.longitude == rhs.longitude &&
		lhs.latitude  == rhs.latitude
	}
}

extension CLLocationCoordinate2D: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(latitude)
		hasher.combine(longitude)
	}
}
