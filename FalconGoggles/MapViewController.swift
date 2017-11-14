//
//  MapViewController.swift
//  FalconGoggles
//
//  Created by M2A User on 11/13/17.
//  Copyright © 2017 Isaiah Butcher. All rights reserved.
//

import UIKit
import MapKit
import CoreMotion

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var motionManager : CMMotionManager!
    
    let initialLocation = CLLocation(latitude:39.008493, longitude: -104.888742)
    
    let regionRadius: CLLocationDistance = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        centerMapOnLocation(location: initialLocation)
        changeMapType()
        // Do any additional setup after loading the view.
        
        let f16 = Monument(title: "F-16 Fightin' Falcon", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.009103, longitude: -104.889707))
        mapView.addAnnotation(f16)
        
        motionManager = CMMotionManager()
//        motionManager.start
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeMapType() {
        mapView.mapType = .satellite
    }
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate{
    func mapView(_mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Monument else{return nil}
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
