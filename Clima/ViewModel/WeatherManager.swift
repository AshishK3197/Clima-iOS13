//
//  WeatherManager.swift
//  Clima
//
//  Created by Ashish Kumar on 15/01/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherDataModel)
    func didFailWithError(error: Error)
}



class WeatherManager {
    let weatherURL  = "https://api.openweathermap.org/data/2.5/weather?appid=dd1214162be4563c89f51323c820bb7e&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        let url = "\(weatherURL)&q=\(city)"
        performRequest(urlString: url)
    }
    
    func fetchWeather(latitude:  CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                    
                }
                if let safeData = data{
                    if  let weather = self.parseJson(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            session.resume()
        }
    }
    
    func parseJson(weatherData: Data)-> WeatherDataModel?{
        do{
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            DatabaseInteraction.sharedInstance.save(object: weather)
            let fetchedData = DatabaseInteraction.sharedInstance.fetchData()
            return fetchedData[fetchedData.count-1]
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}

