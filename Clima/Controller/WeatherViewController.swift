//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationData = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lastData = DatabaseInteraction.sharedInstance.fetchData()
        didUpdateWeather(weather: lastData[lastData.count-1])
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationData.delegate = self
        locationData.requestWhenInUseAuthorization()
        locationData.requestLocation()
        

        // Do any additional setup after loading the view.
    }
 
    @IBAction func locationManager(_ sender: UIButton) {
        
        locationData.requestLocation()
    }
}

//MARK: - UItextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != ""{
            return true
        }else{
            searchTextField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city: city)
        }
        searchTextField.text = ""
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        searchTextField.endEditing(true)
        
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
  
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(weather: WeatherDataModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(weather.temperature)
            self.conditionImageView.image = UIImage(systemName: weather.conditionName! )
            self.cityLabel.text = weather.cityName
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat , longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}




