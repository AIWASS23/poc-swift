import CoreLocation

@available(macOS 10.15, *)
extension CLVisit {
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}