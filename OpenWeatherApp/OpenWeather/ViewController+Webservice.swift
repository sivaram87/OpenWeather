//
//  ViewController+Webservice.swift
//  OpenWeather
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 9/17/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import UIKit
import CoreLocation
// MARK: - Webservice Call

extension ViewController {
    
    // Make a service call based on the city
    func updateWeather(city: String) {
        let service = WebServiceManager()
        service.getWeatherForCity(city: city, completionHandler: ResponseHandler)
        
    }
    
    // Make a service call based on the CLLocation
    
    func locationDidUpdate(location: CLLocation) {
        let service = WebServiceManager()
        service.getWeatherForLocation(location: location, completionHandler: ResponseHandler)
    }
    
    func ResponseHandler(model: WeatherModel?, error: VWError?) {
        guard let model = model else {
            if let err = error {
                self.handleError(err)
            }
            return
        }
        DispatchQueue.main.async(execute: {
            self.lblCity.text = model.cityName
            self.temperature = model.temprature
            if self.toggleCelcius {
                self.lblDegree.text = "\(String(format:"%.0f",round(self.temperature.kelvinToCelsius())))º"
            } else {
                self.lblDegree.text = "\(String(format:"%.0f",round(self.temperature.kelvinToFahrenheit())))º"
            }
            self.lblDescription.text = model.description
            self.imgWeather.imageFromUrl(urlString: constant.iconURL.replacingOccurrences(of: constant.fileName, with: model.iconImage))
        })
    }
    
    func handleError(_ error: VWError) {
        switch error {
        case .InvalidUrl:
            showErrorAlert(title: constant.invalidURL, description: constant.invalidURLMsg)
        case .NetworkFailed(_, _):
            showErrorAlert(title: constant.networkErr, description: constant.networkErrMsg)
        case .InvalidJson(_, let description):
            showErrorAlert(title: constant.invalidJson, description: description)
        }
    }
    func showErrorAlert(title: String, description: String) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: constant.okBtn, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
