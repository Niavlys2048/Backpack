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
        case 200:
            return "200" // Thunderstorm with light rain
        case 201:
            return "201" // Thunderstorm with rain
        case 202:
            return "202" // Thunderstorm with heavy rain
        case 203...232:
            return "211" // Thunderstorm
        case 300...321:
            return "311" // Drizzle rain
        case 500:
            return "500" // Light Rain
        case 501:
            return "501" // Moderate Rain
        case 502-504:
            return "502" // Heavy intensity rain
        case 511:
            return "602" // Freezing rain
        case 520:
            return "520" // Light intensity shower rain
        case 521:
            return "521" // Shower rain
        case 522...531:
            return "522" // Heavy intensity shower rain
        case 600:
            return "600" // Light snow
        case 601:
            return "601" // Snow
        case 602:
            return "602" // Heavy snow
        case 611...615:
            return "600" // Light snow
        case 616...620:
            return "601" // Snow
        case 621...622:
            return "602" // Heavy snow
        case 701...780:
            return "741" // Fog
        case 781:
            return "781" // Tornado
        case 801:
            return "801" // Few clouds: 11-25%
        case 802:
            return "802" // Scattered clouds: 25-50%
        case 803:
            return "803" // Broken clouds: 51-84%
        case 804:
            return "804" // Overcast clouds: 85-100%
        default:
            return "800" // Clear sky
        }
    }
    
    init(weatherResponse: WeatherResponse) {
        self.cityName = weatherResponse.name
        self.timeZone = weatherResponse.timezone
        self.conditionName = weatherResponse.weather[0].main
        self.temperature = weatherResponse.main.temp
        self.conditionId = weatherResponse.weather[0].id
    }
}
