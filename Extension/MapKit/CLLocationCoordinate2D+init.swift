import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
	init?(latitude: String, longitude: String) {
		guard
			let lat = CLLocationDegrees(latitude),
			let lon = CLLocationDegrees(longitude)
		else { return nil }
		
		self.init(
			 latitude: lat.truncatingRemainder(dividingBy: 90),
			longitude: lon.truncatingRemainder(dividingBy: 180)
		)
	}
	
	init?(latitude: String?, longitude: String?) {
		guard
			let latitude = latitude,
			let longitude = longitude,
			let lat = CLLocationDegrees(latitude),
			let lon = CLLocationDegrees(longitude)
		else { return nil }
		
		self.init(
			 latitude: lat.truncatingRemainder(dividingBy: 90),
			longitude: lon.truncatingRemainder(dividingBy: 180)
		)
	}
}

extension CLLocation {
	convenience init(coordinate: CLLocationCoordinate2D) {
		self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
	}
}

extension CLLocationCoordinate2D {
	@inlinable static var zero: CLLocationCoordinate2D { .init() }
	var isZero: Bool { latitude.isZero && longitude.isZero }
	@inlinable var isNotZero: Bool { !isZero }
	var nonZero: CLLocationCoordinate2D? { isZero ? nil : self }
}
