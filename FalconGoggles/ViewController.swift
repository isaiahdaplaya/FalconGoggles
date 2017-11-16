//
//  ViewController.swift
//  FalconGoggles
//
//  Created by Isaiah Butcher on 11/12/17.
//  Copyright © 2017 Isaiah Butcher. All rights reserved.
//
//  Documentation: Used mapKit tutorial to understand basics of displaying maps.
//                 Used CoreLocation tutorial to understand how to retrieve user location.

import CoreMotion
import CoreLocation
import UIKit
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var brngLabel: UILabel!
    
    var motionManager : CMMotionManager!
    let locationManager = CLLocationManager()
    var location : CLLocation!
    
    let monuments = Monument.loadAllMonuments()

    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationLabel.text = "\(String(location.coordinate.latitude)), \(String(location.coordinate.longitude))"
            
            brngLabel.text = "\(headingToLocation(myLoc: location, monumentLoc: monuments[0].coordinate ))"
        }
    }


    
    func headingToLocation(myLoc: CLLocation, monumentLoc: CLLocationCoordinate2D)-> Double{
        var dLon = monumentLoc.longitude - myLoc.coordinate.longitude
        
        var y = sin(dLon) * cos(monumentLoc.latitude)
        var x = cos(myLoc.coordinate.latitude) * sin(monumentLoc.latitude) - sin(myLoc.coordinate.latitude) * cos(monumentLoc.latitude) * cos(dLon)
        
        var brng = atan2(y,x)
        
        brng = brng * 180 / Double.pi
        brng = (brng+360).truncatingRemainder(dividingBy: 360)
        brng = 360-brng
        
        return brng
        
    }

}

