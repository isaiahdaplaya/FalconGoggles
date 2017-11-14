//
//  Monument.swift
//  FalconGoggles
//
//  Created by M2A User on 11/13/17.
//  Copyright © 2017 Isaiah Butcher. All rights reserved.
//

import Foundation
import MapKit

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
}
