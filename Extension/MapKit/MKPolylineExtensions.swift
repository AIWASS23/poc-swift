import MapKit

extension MKPolyline {
    // Create a new MKPolyline from a provided Array of coordinates.
    
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        var refCoordinates = coordinates
        self.init(coordinates: &refCoordinates, count: refCoordinates.count)
    }
}