//
//  WeatherResponse.swift
//  Backpack
//
//  Created by Sylvain Druaux on 28/01/2023.
//

import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let timezone: Int
    let name: String
}

struct Weather: Decodable {
    let id: Int
    let main: String
}

struct Main: Decodable {
    let temp: Double
}
