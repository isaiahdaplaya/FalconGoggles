//
//  ViewController.swift
//  FalconGoggles
//
//  Created by Isaiah Butcher on 11/12/17.
//  Copyright © 2017 Isaiah Butcher. All rights reserved.
//

import CoreMotion
import CoreLocation
import UIKit

class ViewController: UIViewController {
    
    var motionManager : CMMotionManager!
    var location : CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        location = CLLocation()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

