import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let centerLocation = CLLocationCoordinate2D(latitude: 40.572093, longitude: -74.549652)
    
    let grammasHouse = PoolHallAnnotation(title: "Grandmas", address: "705 cedar crest drive", coordinate: CLLocationCoordinate2D(latitude: 40.572093, longitude: -74.549652))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //                      Map view configs
        mapView.delegate = self
        mapView.zoomToUserLocation(centerLocation)
        mapView.mapType = .hybrid
        mapView.addAnnotation(grammasHouse)
        
        checkLocationServices()
        
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



//                  Center around the user location
extension MKMapView {
    func zoomToUserLocation(_ location: CLLocationCoordinate2D) {
        let zoomInMeters: Double = 400
        
        let centerRegion = MKCoordinateRegion(center: location, latitudinalMeters: zoomInMeters, longitudinalMeters: zoomInMeters)
        
        self.setCenter(location, animated: true)
        self.setRegion(centerRegion, animated: true)
    }
    
}

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
            print("Authorization: .authorizedWhenInUse")
            
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
}
