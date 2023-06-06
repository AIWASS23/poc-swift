import SwiftUI
import CoreLocation
import MapKit

struct MapUserLocation: View {
    
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear {
                viewModel.checkIfLocationServicesIsEnable()
            }
    }
}

struct MapUserLocation_Previews: PreviewProvider {
    static var previews: some View {
        MapUserLocation()
    }
}