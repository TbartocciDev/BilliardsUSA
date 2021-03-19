import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var followMeBtn: UIButton!
    
    //          exapndable cards
    var tripInfoCardVC: TripInfoViewCardController!
    let cardHeight: CGFloat = 515
    let handleAreaHeight: CGFloat = 75
    var tripCardVisible: Bool = false
    
    enum CardState {
        case collapsed
        case expanded
    }
    var nextState:CardState {
        return tripCardVisible ? .collapsed : .expanded
    }
    var runningCardAnimations: [UIViewPropertyAnimator] = []
    var animationProgressWhenInterrupted: CGFloat = 0
    var visualEffectView: UIVisualEffectView!
    var tripInfoIsVisible: Bool = false
    
    
    
    let locationManager = CustomLocationManager()
    var isFollowingUser: Bool = true
    
    var directionsPolyLineArray: [MKDirections] = []
    
    let centerLocation = CLLocationCoordinate2D(latitude: 40.572093, longitude: -74.549652)
    let userLocationZoomInMeters: Double = 400
    
    var directionInstructions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //                      Map view configs
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        checkLocationServices()
        
        stopFollowingUser()
        setCardTripInfo()
    }
    
    @IBAction func directionsButtonPressed(_ sender: Any) {
        tripInfoIsVisible = true
        if tripInfoIsVisible {
            tripInfoCardVC.view.isHidden = false
        } else {
            tripInfoCardVC.view.isHidden = true
        }
        getDirections()
        
    }
    @IBAction func followMeButtonPressed(_ sender: Any) {
        isFollowingUser = true
        centerViewOnUserLocation()
        followMeBtn.isHidden = true
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
                
                for step in route.steps {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.roundingMode = .up
                    formatter.maximumFractionDigits = 1
                    let miles = formatter.string(from: NSNumber(value: step.distance / 1609))
                    
//                    print("after \(miles!) miles, \(step.instructions)")
                    directionInstructions.append("After \(miles!) miles, \(step.instructions)")
                    
                }
            }
            print(directionInstructions)
            
        }
        
    }
    
    func setCardTripInfo() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
//        self.view.addSubview(visualEffectView)
        
        tripInfoCardVC = TripInfoViewCardController(nibName: "TripInfoView", bundle: nil)
        self.addChild(tripInfoCardVC)
        self.view.addSubview(tripInfoCardVC.view)
        
        tripInfoCardVC.view.frame = CGRect(x: 0, y: self.view.frame.height - handleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        tripInfoCardVC.view.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTripinfoTapped(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewTripinfoPan(recognizer:)))
        
        tripInfoCardVC.handleAreaView.addGestureRecognizer(tapGesture)
        tripInfoCardVC.handleAreaView.addGestureRecognizer(panGesture)
        
            if tripInfoIsVisible {
                tripInfoCardVC.view.isHidden = false
            } else {
                tripInfoCardVC.view.isHidden = true
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
        directionsPolyLineArray.append(newDirections)
        let _ = directionsPolyLineArray.map {
            $0.cancel()
        }
    }
    
    @objc
    func viewTripinfoTapped(recognizer: UITapGestureRecognizer) {
    
    }
    @objc
    func viewTripinfoPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.8)
        case .changed:
            let translation = recognizer.translation(in: self.tripInfoCardVC.handleAreaView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = tripCardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionComplete: fractionComplete)
        case .ended:
            continueInteractiveTranstion()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningCardAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.tripInfoCardVC.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.tripInfoCardVC.view.frame.origin.y = self.view.frame.height - self.handleAreaHeight
                }
            }
            frameAnimator.addCompletion { (_) in
                self.tripCardVisible = !self.tripCardVisible
                self.runningCardAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningCardAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningCardAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningCardAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    func updateInteractiveTransition(fractionComplete: CGFloat) {
        for animator in runningCardAnimations {
            animator.fractionComplete = fractionComplete + animationProgressWhenInterrupted
        }
    }
    func continueInteractiveTranstion() {
        for animator in runningCardAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
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
        if isFollowingUser == true {
            guard let location = locations.last else {
                print("Could not find user location for updating.")
                return }
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: userLocationZoomInMeters, longitudinalMeters: userLocationZoomInMeters)
            mapView.setRegion(region, animated: true)
            followMeBtn.isHidden = true
        } else {
            followMeBtn.isHidden = false
        }
    }
    
    func stopFollowingUser() {
        let tapMapGesture = UnfollowTapGestureRecognizer(target: nil, action: nil)
        tapMapGesture.touchesBeganCallback = {
            _, _ in
            self.isFollowingUser = false
            print("not following user")
            self.followMeBtn.isHidden = false
            
        }
        mapView.addGestureRecognizer(tapMapGesture)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
