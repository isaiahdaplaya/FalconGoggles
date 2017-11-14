//
//  MapViewController.swift
//  FalconGoggles
//
//  Created by M2A User on 11/13/17.
//  Copyright © 2017 Isaiah Butcher. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let initialLocation = CLLocation(latitude:39.008493, longitude: -104.888742)
    
    let regionRadius: CLLocationDistance = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        centerMapOnLocation(location: initialLocation)
        changeMapType()
        // Do any additional setup after loading the view.
        
        let allMonuments = loadAllMonuments()
        mapView.addAnnotations(allMonuments)
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

    func loadAllMonuments() -> [Monument]{
        let f16 = Monument(title: "F-16 Fightin' Falcon", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.009103, longitude: -104.889707))
        let f15 = Monument(title: "F-15 Eagle", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.007789, longitude: -104.889707))
        let f4 = Monument(title: "F-4 Phantom", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.007789, longitude: -104.887727))
        let f105 = Monument(title: "F-105 Thunderchief", locationName: "TZO", type: "Plane", coordinate: CLLocationCoordinate2D(latitude: 39.009203, longitude: -104.887727))
        
        return [f16,f15,f4,f105]
    }

}

extension MapViewController: MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // 2
            guard let annotation = annotation as? Monument else { return nil }
            // 3
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView { 
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                        size: CGSize(width: 30, height: 30)))
                mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControlState())
                view.rightCalloutAccessoryView = mapsButton
            }
            return view
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Monument
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
