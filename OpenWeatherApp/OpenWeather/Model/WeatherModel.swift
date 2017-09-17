//
//  WeatherModel.swift
//  OpenWeather
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 9/17/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
struct WeatherModel {
    var cityName: String = ""
    var iconImage: String = ""
    var description: String = ""

    var temprature: Float = 0.0
    var pressure: Float = 0.0
    var humidity: Float = 0.0
    
    var windSpeed: Float = 0.0
    var sunrise: Float = 0.0
    var sunset: Float = 0.0
    
    init(jsonData: [String: Any]) {
        if let name = jsonData["name"] as? String {
            cityName = name
        }
        
        if let weather = jsonData["weather"], let firstItem = (weather as? [AnyObject])?.first {
            if let icon = firstItem["icon"] as? String, let description = firstItem["description"] as? String {
                self.iconImage = icon
                self.description = description
            }
        }
        
        if let mainOption = jsonData["main"] as? [String: Float],
            let temp = mainOption["temp"],
            let pressure = mainOption["pressure"],
            let humidity = mainOption["humidity"] {
            self.temprature = temp
            self.pressure = pressure
            self.humidity = humidity
        }
        
        if let wind = jsonData["wind"] as? [String: Float], let speed = wind["speed"] {
            self.windSpeed = speed
        }
        
        if let Sys = jsonData["sys"] as? [String: AnyObject],
            let sunrise = Sys["sunrise"] as? Float,
            let sunset = Sys["sunset"] as? Float {
            self.sunset = sunset
            self.sunrise = sunrise
        }
    }
}
