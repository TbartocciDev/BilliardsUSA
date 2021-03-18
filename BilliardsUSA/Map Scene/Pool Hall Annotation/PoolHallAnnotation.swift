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
    let title: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        address: String?,
        coordinate: CLLocationCoordinate2D
      ) {
        self.title = title
        self.address = address
        self.coordinate = coordinate

        super.init()
      }

      var subtitle: String? {
        return address
      }
    
    var mapItem: MKMapItem? {
      guard let location = address else {
        return nil
      }

      let addressDict = [CNPostalAddressStreetKey: location]
      let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
}
