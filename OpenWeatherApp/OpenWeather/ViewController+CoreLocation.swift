//
//  ViewController+CoreLocation.swift
//  OpenWeather
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 9/17/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location)")
            self.locationDidUpdate(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error finding location: \(error.localizedDescription)")
    }
}

