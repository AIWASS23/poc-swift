import SwiftUI
import MapKit

struct MapLocationAndWeatherCard: View {

    @ObservedObject var weather = WeatherManager()
    @StateObject var locationManager = LocationManager()
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.83834587046632,
            longitude: 14.254053016537693),
        span: MKCoordinateSpan(
            latitudeDelta: 0.05,
            longitudeDelta: 0.05
        )
    )
    @State var city = "Loading"

    var body: some View {
//        if locationManager.authorizationStatus == .authorizedWhenInUse {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .frame(width: 352, height: 188)

                HStack {
                    Text(city)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                    Text(weather.temp)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding(.leading, 32)
                .padding(.trailing, 32)
                .padding(.bottom, 120)
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .task {
                await weather.getWeather(
                    latitude: locationManager.latitude,
                    longitude: locationManager.longitude
                )
            }
            .onAppear {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: locationManager.latitude,
                        longitude: locationManager.longitude),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.05,
                        longitudeDelta: 0.05
                    )
                )

                let geocoder = CLGeocoder()
                let location = CLLocation(
                    latitude: region.center.latitude,
                    longitude: region.center.longitude
                )

                geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, _ -> Void in
                    guard let placemark = placemarks?.first else { return }

                    guard let currentCity = placemark.locality else { return }

                    guard let state = placemark.administrativeArea else { return }

                    city = "\(currentCity), \(state)"

                })
            }

//        } else {
//            Text("Error Loading Location")
//        }
    }
}

struct InsideARouteView_Previews: PreviewProvider {

    static var previews: some View {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 40.83834587046632,
                longitude: 14.254053016537693),
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
        )
        MapLocationAndWeatherCard(region: region)
    }
}
