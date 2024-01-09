import Foundation
import CoreLocation

@Observable
class LocationManager {
    var location: CLLocation?

    private let locationManager = CLLocationManager()

    func requestUserAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
    }

    func startCurrentLocationUpdates() async throws {
        for try await update in CLLocationUpdate.liveUpdates(.default   ) {
            if let location = update.location {
                self.location = location
            } else {
                print("LOCATION update failed")
                return
            }
        }
    }
}
