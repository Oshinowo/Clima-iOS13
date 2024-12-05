//
//  WeatherData.swift
//  Clima
//
//  Created by Big Field Digital on 09/11/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [CityWeather]
}

struct Main: Codable {
    let temp: Double
}


struct CityWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
