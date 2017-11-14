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
}
