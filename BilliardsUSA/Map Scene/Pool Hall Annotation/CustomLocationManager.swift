//
//  CustomLocationManager.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 3/18/21.
//

import UIKit
import CoreLocation
import MapKit

//                  This class is used to get rid of an error message that comes along with standard location manager

class CustomLocationManager: CLLocationManager {
    private var _location: CLLocation?
    var anyLocationDelivered = false
    @objc dynamic override var location: CLLocation? {
        get {
            guard anyLocationDelivered else { return nil }
            let usedLocation = _location ?? super.location
            return usedLocation
        }
        set {
            _location = newValue
        }
    }
}
