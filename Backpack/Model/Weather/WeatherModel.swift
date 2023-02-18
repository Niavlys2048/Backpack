//
//  WeatherModel.swift
//  Backpack
//
//  Created by Sylvain Druaux on 28/01/2023.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let timeZone: Int
    let conditionName: String
    
    let temperature: Double
    
    var temperatureCelsius: String {
        return temperature.displayRoundedToInteger
    }
    
    var temperatureFahrenheit: String {
        return ((temperature * 9/5) + 32).displayRoundedToInteger
    }
    
    let conditionId: Int
    var conditionImage: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "sun.min"
        }
    }
}
