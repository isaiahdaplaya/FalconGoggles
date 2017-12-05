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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    var motionManager : CMMotionManager!
    let locationManager = CLLocationManager()
    var location : CLLocation!
    
    var bearingToF16: Double = 0.0

    let buffer: Double = 5
    
    let monuments = Monument.loadAllMonuments()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

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
        addTapGestureToSceneView()
        // Do any additional setup after loading the view, typically from a nib.
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
            
            
            print(newHeading.trueHeading)
            
            if(myBearing <= bearingToMonument + 5 && myBearing >= bearingToMonument - 5){
//                DescriptionLabel.isHidden = false
//                DescriptionLabel.text = monument.title
//
                monument.isTargeting = true
                
            }else{
//                DescriptionLabel.isHidden = true
                monument.isTargeting = false
            }
        }
        
        var isThereAHit = false
        var theTarget: Monument?
        
        for monument in monuments{
            if monument.isTargeting == true{
                isThereAHit = true
                theTarget = monument
            }
        }
        
        if isThereAHit == true{
            let targetLocation = CLLocation(latitude: theTarget!.coordinate.latitude, longitude: theTarget!.coordinate.longitude)
           addCone(topRadius: CGFloat(location.distance(from: targetLocation) / 10), bottomRadius: 0, height: CGFloat(location.distance(from: targetLocation) / 5), distance: Float(location.distance(from: targetLocation)))
        }else{
           
        }
        
    }


    
    func headingToLocation(myLoc: CLLocation, monumentLoc: CLLocationCoordinate2D)-> Double{
        let offset = 0.0
        
        let dLon = monumentLoc.longitude - myLoc.coordinate.longitude
        
        let y = sin(dLon) * cos(monumentLoc.latitude)
        let x = cos(myLoc.coordinate.latitude) * sin(monumentLoc.latitude) - sin(myLoc.coordinate.latitude) * cos(monumentLoc.latitude) * cos(dLon)
        
        var brng = atan2(y,x)
        
        brng = brng * 180 / Double.pi
        brng = (brng+360).truncatingRemainder(dividingBy: 360)
//        brng = 360-brng
        
        return brng + offset
        
    }
    
    func addCone(topRadius: CGFloat = 1, bottomRadius: CGFloat = 0, height: CGFloat = 2, distance: Float = 0.2) {
        let cone = SCNCone(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        
        let coneNode = SCNNode()
        coneNode.geometry = cone
        coneNode.position = SCNVector3(0, 0, (distance * -1))
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(coneNode)
        sceneView.scene = scene
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
extension float4x4 {
    var translation : float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

