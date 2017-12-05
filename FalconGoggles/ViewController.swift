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
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var brngLabel: UILabel!
    
    var motionManager : CMMotionManager!
    let locationManager = CLLocationManager()
    var location : CLLocation!
    
    var bearingToF16: Double = 0.0
    
    let buffer: Double = 5
    
    let monuments = Monument.loadAllMonuments()
    
    @IBOutlet weak var myPhoneBearingLable: UILabel!
    @IBOutlet weak var F16BearingLabel: UILabel!
    @IBOutlet weak var F15BearingLabel: UILabel!
    @IBOutlet weak var F105BearingLabel: UILabel!
    @IBOutlet weak var F4BearingLabel: UILabel!
    @IBOutlet weak var ChapelBearingLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DescriptionLabel.isHidden = true
        motionManager = CMMotionManager()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myLocation = locations.first {
            locationLabel.text = "\(String(myLocation.coordinate.latitude)), \(String(myLocation.coordinate.longitude))"
            
            location=myLocation
            
            brngLabel.text = "\(headingToLocation(myLoc: location, monumentLoc: monuments[0].coordinate ))"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        DescriptionLabel.text = String(newHeading.trueHeading)
        
        for monument in monuments{
            
            
            
            guard let location = location else {return}
            
            let bearingToMonument = headingToLocation(myLoc: location, monumentLoc: monument.coordinate)
            
            let testDist = monument.getDistance(userLoc: location)
            
            if monument.title == "F-16 Fightin' Falcon"{
                F16BearingLabel.text = String(bearingToMonument)
            }else if monument.title == "F-15 Eagle"{
                F15BearingLabel.text = String(bearingToMonument)
            }else if monument.title == "F-4 Phantom"{
                F4BearingLabel.text = String(bearingToMonument)
            }else if monument.title == "F-105 Thunderchief"{
                F105BearingLabel.text = String(bearingToMonument)
            }else{
                ChapelBearingLabel.text = String(bearingToMonument)
            }
            
            let myBearing = newHeading.trueHeading
            
            myPhoneBearingLable.text = String(myBearing)
            
            if(myBearing <= bearingToMonument + 5 && myBearing >= bearingToMonument - 5){
//                DescriptionLabel.isHidden = false
//                DescriptionLabel.text = monument.title
//
                monument.isTargeting = true
                
            }else{
//                DescriptionLabel.isHidden = true
                monument.isTargeting = false
            }
            
            print((locationManager.location?.distance(from: CLLocation(latitude: monument.coordinate.latitude, longitude: monument.coordinate.longitude)))!)
        }
        
        var isThereAHit = false
        var theTarget: Monument?
        var myMonuments: [Monument] = []
        var minDist = 100000000000.0
        
        for monument in monuments{
            if monument.isTargeting == true{
                isThereAHit = true
                myMonuments.append(monument)

            }
        }
        
        for monument in myMonuments{
            if monument.getDistance(userLoc: location) < minDist{
                minDist = monument.getDistance(userLoc: location)
                theTarget = monument
            }
        }
        
        if isThereAHit == true{
            DescriptionLabel.isHidden = false
            DescriptionLabel.text = theTarget!.title
        }else{
            DescriptionLabel.isHidden = true
        }
        
    }


    
    func headingToLocation(myLoc: CLLocation, monumentLoc: CLLocationCoordinate2D)-> Double{
        var offset = 0.0
        var posOrNeg = 0.0
        
        let dLon = monumentLoc.longitude - myLoc.coordinate.longitude
        
        let y = sin(dLon) * cos(monumentLoc.latitude)
        let x = cos(myLoc.coordinate.latitude) * sin(monumentLoc.latitude) - sin(myLoc.coordinate.latitude) * cos(monumentLoc.latitude) * cos(dLon)
        
        var brng = atan2(y,x)
        
        brng = brng * 180 / Double.pi
        brng = (brng+360).truncatingRemainder(dividingBy: 360)
//        brng = 360-brng
        
        let testOffestBrng = (brng).truncatingRemainder(dividingBy: 90)
        
        if (brng > 90 && brng < 180) || (brng > 270 && brng < 360){
            posOrNeg = -1.0
        }else{
            posOrNeg = 1.0
        }
        if testOffestBrng > 80 || testOffestBrng < 10 {
            offset = 0.0
        }else if (testOffestBrng <= 80 && testOffestBrng > 60) || (testOffestBrng >= 10 && testOffestBrng <= 30){
            offset = 15.0
        }else if (testOffestBrng <= 60 && testOffestBrng > 50) || (testOffestBrng >= 30 && testOffestBrng <= 40){
            offset = 30.0
        }else{
            offset = 40.0
        }
        
        return brng + (offset * posOrNeg)
        
    }

}

