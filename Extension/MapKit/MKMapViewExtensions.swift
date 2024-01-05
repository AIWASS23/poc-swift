import MapKit

extension MKMapView {
    // Dequeue reusable MKAnnotationView using class type.
    
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type) -> T? {
        return dequeueReusableAnnotationView(withIdentifier: String(describing: name)) as? T
    }

    // Register MKAnnotationView using class type.
    
    func register<T: MKAnnotationView>(annotationViewWithClass name: T.Type) {
        register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: name))
    }

    // Dequeue reusable MKAnnotationView using class type.
    
    func dequeueReusableAnnotationView<T: MKAnnotationView>(
        withClass name: T.Type,
        for annotation: any MKAnnotation
    ) -> T? {
        guard let annotationView = dequeueReusableAnnotationView(
            withIdentifier: String(describing: name),
            for: annotation
        ) as? T else {
            fatalError("Couldn't find MKAnnotationView for \(String(describing: name))")
        }

        return annotationView
    }

    // Zooms in on multiple mapView coordinates.
    
    func zoom(
        to coordinates: [CLLocationCoordinate2D], 
        meter: Double, edgePadding: SFEdgeInsets, 
        animated: Bool
    ) {
        guard !coordinates.isEmpty else { return }

        if coordinates.count == 1 {
            let coordinateRegion = MKCoordinateRegion(
                center: coordinates.first!,
                latitudinalMeters: meter,
                longitudinalMeters: meter)
            setRegion(coordinateRegion, animated: true)
        } else {
            let mkPolygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            setVisibleMapRect(mkPolygon.boundingMapRect, edgePadding: edgePadding, animated: animated)
        }
    }
}