struct MapView: UIViewRepresentable {
    
    let distance: CLLocationDistance = 200
    let pitch: CGFloat = 400
    let heading = 90.0
    let coordinate = CLLocationCoordinate2DMake(40.68924124412252, -74.04457550374869)
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .satelliteFlyover
        
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: distance, pitch: pitch, heading: heading)
        mapView.camera = camera
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}

struct FlyoverMap: View {
    var body: some View {
        MapView()
            .ignoresSafeArea()
    }
}