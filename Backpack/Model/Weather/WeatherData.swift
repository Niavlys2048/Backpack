//
//  WeatherData.swift
//  Backpack
//
//  Created by Sylvain Druaux on 28/01/2023.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let timezone: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
}
