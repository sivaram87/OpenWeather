//
//  WebServiceManager.swift
//  OpenWeather
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 9/17/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
import CoreLocation

typealias weatherHandler = (_ object: WeatherModel?, _ error: VWError?) -> Void

class WebServiceManager {
    fileprivate let appId = "a8fe49884364d03a655e1fd715f27797"
    fileprivate let apiUrl = "http://api.openweathermap.org/data/2.5/weather"
    
    fileprivate func generateURL(city: String) -> URL? {
        guard var component = URLComponents(string: apiUrl) else {
            return nil
        }
        component.queryItems = [URLQueryItem(name: "q", value: city),
                                URLQueryItem(name: "appid", value: appId)]
        return component.url
    }
    
    fileprivate func generateURL(location: CLLocation) -> URL? {
        guard var component = URLComponents(string: apiUrl) else {
            return nil
        }
        component.queryItems = [URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
                                URLQueryItem(name: "lon", value: String(location.coordinate.longitude)),
                                URLQueryItem(name: "appid", value: appId)]
        return component.url
    }
    
    func getWeatherForLocation(location: CLLocation, completionHandler: @escaping weatherHandler) {
        guard let url = generateURL(location: location) else {
            completionHandler(nil, VWError.InvalidUrl)
            return
        }
        retrieveWeatherURL(url: url, completionHandler: completionHandler)
    }
    
    func getWeatherForCity(city: String, completionHandler: @escaping weatherHandler) {
        guard let url = generateURL(city: city) else {
            completionHandler(nil, VWError.InvalidUrl)
            return
        }
        retrieveWeatherURL(url: url, completionHandler: completionHandler)
    }
    func retrieveWeatherURL(url: URL, completionHandler: @escaping weatherHandler) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request,
                                    completionHandler: { data, response, networkError in
                                        if let _ = networkError {
                                            if let code = response as? HTTPURLResponse {
                                                completionHandler(nil, VWError.NetworkFailed(code: code.statusCode, description: networkError.debugDescription))
                                            } else {
                                                completionHandler(nil, VWError.NetworkFailed(code: 400, description: networkError.debugDescription))
                                            }
                                            return
                                        }
                                        
                                        guard let data = data else {
                                            completionHandler(nil, VWError.NetworkFailed(code: 400, description: ""))
                                            return
                                        }
                                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                            print(json.debugDescription)
                                            let model = WeatherModel(jsonData: json!)
                                            completionHandler(model, nil)
                                        } else {
                                            completionHandler(nil, VWError.InvalidJson(code: 999, description: "Unable to parse Json"))
                                        }
        })
        task.resume()
    }
    
}
