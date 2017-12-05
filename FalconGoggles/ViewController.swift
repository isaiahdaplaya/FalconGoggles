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
import ARKit
import SceneKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var sceneLocationView = SceneLocationView()
    var annotatedNode : LocationAnnotationNode? = nil
    var motionManager : CMMotionManager!
    let locationManager = CLLocationManager()
    var location : CLLocation!
    
    var bearingToF16: Double = 0.0

    let buffer: Double = 5
    
    let monuments = Monument.loadAllMonuments()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        motionManager = CMMotionManager()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        }
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        view.sendSubview(toBack: sceneLocationView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myLocation = locations.first {
            
            
            location=myLocation
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        
        for monument in monuments{
            
            
            
            guard let location = location else {return}
            
            let bearingToMonument = headingToLocation(myLoc: location, monumentLoc: monument.coordinate)
            
            
            let myBearing = newHeading.trueHeading
            
            
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
           let targetLocation: CLLocation = CLLocation(coordinate: (theTarget?.coordinate)!, altitude: 2170)
            let image = UIImage(named: "pin")
            
            annotatedNode = LocationAnnotationNode(location: targetLocation, image: image!)
            annotatedNode!.scaleRelativeToDistance = true
            
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotatedNode!)
            
            
            infoLabel.text = theTarget!.theDescription
        }
        else {
            sceneLocationView.removeAllLocationNodes()
//            guard let annotatedNodes = annotatedNode else {return}
//            sceneLocationView.removeLocationNode(locationNode: annotatedNodes)
//            annotatedNode = nil
            infoLabel.text = "Searching..."
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
    
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer : UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {return}
        node.removeFromParentNode()
    }

}


