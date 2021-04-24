//
//  PoolHallAnnotation.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 3/17/21.
//

import UIKit
import MapKit
import Contacts
import CoreLocation

class PoolHallAnnotation: NSObject, MKAnnotation {
    var title: String?
    var address: String?
    var coordinate: CLLocationCoordinate2D
    var type: String?
    
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D, type: String) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
        self.type = type
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
    
}
