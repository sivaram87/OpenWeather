//
//  ViewController.swift
//  OpenWeather
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 9/17/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var btnCelcius: UIButton!
    @IBOutlet weak var btnFarenheit: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate let locationManager = CLLocationManager()
    
    var arrSearchList: [String] = []
    
    var toggleCelcius: Bool = true {
        didSet{
            self.btnCelcius.isEnabled = !toggleCelcius
            self.btnFarenheit.isEnabled = toggleCelcius
        }
    }
    
    var temperature: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        toggleCelcius = true
        
        self.tableView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.txtCity.delegate = self
        //Invoke Location service for initial load
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        WebServiceManager.getCitiList(text: "Sivak")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBOutlets
    @IBAction func actionGo(_ sender: Any?) {
        guard let text = txtCity.text, text != "" else {
            return
        }
        self.txtCity.resignFirstResponder()
        self.updateWeather(city: text)
        if !self.arrSearchList.contains(text.lowercased()) {
            self.arrSearchList.append(text.lowercased())
        }
        self.tableView.isHidden = true
        self.txtCity.text = ""
    }
    
    @IBAction func actionCelcius(_ sender: Any) {
        toggleCelcius = true
        self.lblDegree.text = "\(String(format:"%.0f",round(self.temperature.kelvinToCelsius())))º"
    }
    
    @IBAction func actionFarenheit(_ sender: Any) {
        toggleCelcius = false
        self.lblDegree.text = "\(String(format:"%.0f",round(self.temperature.kelvinToFahrenheit())))º"
    }
    
    // MARK: UITableView Delegate & Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrSearchList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.arrSearchList[indexPath.row]
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.txtCity.text = self.arrSearchList[indexPath.row]
        self.tableView.isHidden = true
        self.txtCity.resignFirstResponder()

    }

}

// MARK: - UITextField Delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.arrSearchList.count > 0 {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.actionGo(nil)
        return true
    }
}

