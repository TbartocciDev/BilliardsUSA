//
//  NewMapViewController.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/23/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stateCenterBtn: UIButton!
    @IBOutlet weak var stateNameLbl: UILabel!
    
    var stateCenterLat: CLLocationDegrees = 0
    var stateCenterLong: CLLocationDegrees = 0
    var stateZoom: CLLocationDegrees = 850000
    var stateScrollDistanceLat: CLLocationDistance = 200000
    var stateScrollDistanceLong: CLLocationDistance = 450000
    
    var poolHallsArr: [PoolHall] = []
    var poolHallsAnotationsArr: [PoolHallAnnotation] = []
    
//    31.545435327299316, -98.67873711857305
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        stateCenterBtn.addTarget(self, action: #selector(centerMapToState), for: .touchUpInside)
        
    }
    
    
    func configureMapView(state: State) {
        stateNameLbl.text = state.name
        stateCenterBtn.setTitle("Center to \(state.abrev)", for: .normal)
        stateCenterLat = state.centerLat
        stateCenterLong = state.centerLong
        stateScrollDistanceLat = state.stateScrollLat
        stateScrollDistanceLong = state.stateScrollLong
        stateZoom = state.stateZoom
        
        poolHallsArr = state.poolhalls
        
    }
    
    
    @objc func
    centerMapToState() {
        
        let stateCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: stateCenterLat, longitude: stateCenterLong)
        
        let regionOfState = MKCoordinateRegion(center: stateCenter, latitudinalMeters: stateZoom, longitudinalMeters: stateZoom)
        let scrollRegionState = MKCoordinateRegion(center: stateCenter, latitudinalMeters: stateScrollDistanceLat, longitudinalMeters: stateScrollDistanceLong)
        
        let cameraBoundaryState = MKMapView.CameraBoundary(coordinateRegion: scrollRegionState)
        
        mapView.setRegion(regionOfState, animated: true)
        parsePoolHallAnnotations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mapView.setCameraBoundary(cameraBoundaryState, animated: false)
        }
        
    }
    
    func parsePoolHallAnnotations() {
        
        let BDB = PoolHallAnnotation(title: "Black Diamond Billiards", address: "1767 Rt. 22 West, Union, NJ 07083", coordinate: CLLocationCoordinate2D(latitude: 40.69628930152243, longitude: -74.25630171378178), type: "Hall")
        let GNDB = PoolHallAnnotation(title: "Guys and Dolls Billiards", address: "524 Washington Ave, Belleville, NJ 07109", coordinate: CLLocationCoordinate2D(latitude: 40.79858056344833, longitude: -74.14749245998183), type: "Bar")
        let BAE = PoolHallAnnotation(title: "Break Away Entertainment", address: "17 Minneakoning Rd, Flemington, NJ 08822", coordinate: CLLocationCoordinate2D(latitude: 40.53146826937601, longitude: -74.85071584649751), type: "Hall")
        
        poolHallsAnotationsArr.append(BDB)
        poolHallsAnotationsArr.append(GNDB)
        poolHallsAnotationsArr.append(BAE)
        
        mapView.addAnnotations(poolHallsAnotationsArr)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
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
            
            let callOutDistance: CGFloat = 5
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: callOutDistance)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            if annotation.type == "Hall" {
                view.glyphText = "Hall"
                view.glyphTintColor = .white
            } else {
                view.glyphText = "Bar"
                view.glyphTintColor = .white
            }
            
        }
        return view
    }
}
