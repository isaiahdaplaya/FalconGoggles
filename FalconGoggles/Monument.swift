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
    let theDescription: String
    var isTargeting: Bool
    
    init(title:String, locationName: String, type: String, coordinate: CLLocationCoordinate2D, theDescription: String){
        self.title = title
        self.locationName = locationName
        self.type = type
        self.coordinate = coordinate
        self.isTargeting = false
        self.theDescription = theDescription
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
    
    func getDistance(userLoc: CLLocation) -> CLLocationDistance {
        return (userLoc.distance(from: CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)))
    }
    
    static func loadAllMonuments() -> [Monument]{
        let f16 = Monument(title: "F-16 Fightin' Falcon", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.009103, longitude: -104.889707), theDescription: "F16 - Originally a non-flying test bed aircraft, this F-16 was donated by AFMC (formerly AFSC) at Wright-Patterson AFB, OH, and is presently painted in the colors of the 57th Fighter Weapons Wing at Nellis AFB, NV")
        let f15 = Monument(title: "F-15 Eagle", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.007789, longitude: -104.889707), theDescription: "F15 - This 1976 model F-15 flew most of its career with the 48th Fighter Interceptor Squadron (FIS) at Langley AFB, VA. The 48 FIS flew the jet on intercept missions for the Southeast Air Defense Sector. The jet was painted in the colors of Tyndall AFB, FL, for its last few missions before it was retired on 30 November 1992. It was donated in 1993.")
        let f4 = Monument(title: "F-4 Phantom", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.007789, longitude: -104.887727), theDescription: "F4 - This is the only aircraft credited with six MiG kills since the Korean War. Captain Richard S. Ritchie, Class of 1964, made his first and fifth kills in this aircraft. It was presented to the Academy in 1986.")
        let f105 = Monument(title: "F-105 Thunderchief", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.009103, longitude: -104.887727), theDescription: "F105 - Assembled at McClellan AFB, CA, from parts of at least 10 sister aircraft that saw combat duty in Southeast Asia, this aircraft has served as a permanent memorial at the Academy since 1968.")
        let chapel = Monument(title: "Cadet Chapel", locationName: "Visitor's Area", type: "Chapel", coordinate: CLLocationCoordinate2D(latitude: 39.008426, longitude: -104.890388), theDescription: "Chapel - The Cadet Chapel is both the most recognizable building at the United States Air Force Academy and the most visited man-made tourist attraction in Colorado. This aluminum, glass and steel structure features 17 spires that shoot 150 feet into the sky. It is considered among the most beautiful examples of modern American academic architecture.")
        return [f16,f15,f4,f105,chapel]
    }
}
