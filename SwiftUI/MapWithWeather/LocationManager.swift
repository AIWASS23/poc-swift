import Foundation
import CoreLocation

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?

    var latitude: Double {
        locationManager.location?.coordinate.latitude ?? 0.0
    }
    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? 0.0
    }
    var city: Double {
        locationManager.location?.altitude ?? 0.0
    }

    override init() {
        super.init()
        locationManager.delegate = self
    }

//    func getNameCurrentLocation() {
//
//    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break

        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break

        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break

        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
