//
//  PoolHall.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/23/21.
//

import UIKit
import MapKit


struct Search: Codable {
    var search: [State]
}

struct State: Codable {
    var name: String
    var abrev: String
    var centerLat: Double
    var centerLong: Double
    var stateZoom: Double
    var stateScrollLat: Double
    var stateScrollLong: Double
    var poolhalls: [PoolHall]
}

struct PoolHall: Codable {
    var name: String
    var address: String
    var website: String
    var phoneNum: String
    var rating: String
    var location: geoLocation
    
}

struct geoLocation: Codable {
    var lat: String
    var long: String
}
