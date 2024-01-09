import CoreLocation

extension CLLocationCoordinate2D: Equatable {

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        (lhs.longitude == rhs.longitude) && (lhs.latitude == rhs.latitude)
    }

}
