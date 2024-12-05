//
//  WeatherManager.swift
//  Clima
//
//  Created by Big Field Digital on 22/10/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel?)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let url: String = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=2f0a6596ac1b399efb56363342bd342e"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchData(cityName: String) {
        let weatherUrl = "\(url)&q=\(cityName)"
        //        print(weatherUrl)
        //        performRequest(urlString: weatherUrl)
        performRequest(with: weatherUrl)
    }
    
    func fetchData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let weatherUrl = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: weatherUrl)
    }
    
    func performRequest(with urlString: String) {
        
        //        1. Create URL
        if let url = URL(string: urlString) {
            
            //        2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //        3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    //                    print(error!)
                    return
                }
                
                if let safeData = data {
                    //                    let dataString = String(data: safeData, encoding: .utf8)
                    //                    print(dataString!)
                    let weather = parseJSON(safeData)
                    delegate?.didUpdateWeather(self, weather: weather)
                }
            }
            
            //        4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //            print(decodedData.weather[0].icon)
            let weatherId = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: weatherId, cityName: name, temperature: temperature)
            return weather
            //   print(weather.temperatureString)
            
        } catch {
            delegate?.didFailWithError(error: error)
            //            print(error)
            return nil
        }
    }
    
}
