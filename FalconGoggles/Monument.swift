//
//  Monument.swift
//  FalconGoggles
//
//  Created by M2A User on 11/13/17.
//  Copyright © 2017 Isaiah Butcher. All rights reserved.
//

import MapKit
import Contacts

class Monument: NSObject, MKAnnotation{
    let title: String?
    let locationName: String
    let type: String
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, locationName: String, type: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.type = type
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String?{
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    static func loadAllMonuments() -> [Monument]{
        let f16 = Monument(title: "F-16 Fightin' Falcon", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.009103, longitude: -104.889707))
        let f15 = Monument(title: "F-15 Eagle", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.007789, longitude: -104.889707))
        let f4 = Monument(title: "F-4 Phantom", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.007789, longitude: -104.887727))
        let f105 = Monument(title: "F-105 Thunderchief", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.009203, longitude: -104.887727))
        
        return [f16,f15,f4,f105]
    }
}
