//
//  Double+Temprature.swift
//  OpenWeather
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 9/17/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
extension Float {
    func kelvinToCelsius() -> Float {
        return self - 273.15
    }
    
    func kelvinToFahrenheit() -> Float {
        return self * 9 / 5 - 459.67
    }
    
}
