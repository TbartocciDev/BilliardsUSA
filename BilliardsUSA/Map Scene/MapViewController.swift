import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CustomLocationManager()
    
    var directionsArray: [MKDirections] = []
    
    let centerLocation = CLLocationCoordinate2D(latitude: 40.572093, longitude: -74.549652)
    let userLocationZoomInMeters: Double = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //                      Map view configs
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        checkLocationServices()
        
    }
    
    @IBAction func directionsButtonPressed(_ sender: Any) {
        getDirections()
    }
    
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            print("Could nto find user location for directions.")
            return }
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(with: directions)
        
        directions.calculate { [unowned self] (response, error) in
            
            guard let response = response else {
                print("Error finding directions: \(error!)")
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                let extraDirectionPaddings: Double = 10000
                let halfExtraDirectionPaddings: Double = 5000
                let newMapRect = MKMapRect(x: route.polyline.boundingMapRect.minX - halfExtraDirectionPaddings, y: route.polyline.boundingMapRect.minY - halfExtraDirectionPaddings, width: (route.polyline.boundingMapRect.width + extraDirectionPaddings), height: (route.polyline.boundingMapRect.height + extraDirectionPaddings))
                self.mapView.setVisibleMapRect(newMapRect, animated: true)
            }
            
        }
        
    }
    
    func getPoolHallLocation() -> CLLocationCoordinate2D{
        
        return CLLocationCoordinate2D(latitude: 40.6568799738109, longitude: -74.40087854862213)
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request{
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destinationLocation = MKPlacemark(coordinate: getPoolHallLocation())
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .automobile
//        request.requestsAlternateRoutes = true
        
        return request
    }
    
    func resetMapView(with newDirections: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(newDirections)
        let _ = directionsArray.map {
            $0.cancel()
        }
    }
    
    
}


//                  Map Kit Delegates
extension MapViewController: MKMapViewDelegate {
    
    //              Rendering for directions polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
    
    //              button pressed on annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //          bring up detail view for pool hall
        
    }
    //              Annoation Clicked
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //          Bring up detail at the bottom?
        
    }
    
    //              Pool Hall Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PoolHallAnnotation else {
          return nil
        }

        let identifier = "poolhall"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {

          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}



//                  location services
extension MapViewController: CLLocationManagerDelegate {
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            //tell the user to turn on location servics
            
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: userLocationZoomInMeters, longitudinalMeters: userLocationZoomInMeters)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("Authorization: .notDetermined")
            
        case .restricted:
            print("Authorization: .restricted")
            
        case .denied:
            print("Authorization: .denied")
            
        case .authorizedAlways:
            print("Authorization: .authorizedAlways")
            
        case .authorizedWhenInUse:
            //              same as allow once
            print("Authorization: .authorizedWhenInUse")
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
        @unknown default:
            print("Authorization: .unknownDefault")
        }
    }
    
    
    //              follows user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.anyLocationDelivered = true
        guard let location = locations.last else {
            print("Could not find user location for updating.")
            return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: userLocationZoomInMeters, longitudinalMeters: userLocationZoomInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
