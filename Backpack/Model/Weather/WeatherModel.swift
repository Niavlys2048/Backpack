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
        temperature.displayRoundedToInteger
    }

    var temperatureFahrenheit: String {
        ((temperature * 9 / 5) + 32).displayRoundedToInteger
    }

    let conditionId: Int
    var conditionImage: String {
        switch conditionId {
        case 200:
            "200" // Thunderstorm with light rain
        case 201:
            "201" // Thunderstorm with rain
        case 202:
            "202" // Thunderstorm with heavy rain
        case 203...232:
            "211" // Thunderstorm
        case 300...321:
            "311" // Drizzle rain
        case 500:
            "500" // Light Rain
        case 501:
            "501" // Moderate Rain
        case 502 - 504:
            "502" // Heavy intensity rain
        case 511:
            "602" // Freezing rain
        case 520:
            "520" // Light intensity shower rain
        case 521:
            "521" // Shower rain
        case 522...531:
            "522" // Heavy intensity shower rain
        case 600:
            "600" // Light snow
        case 601:
            "601" // Snow
        case 602:
            "602" // Heavy snow
        case 611...615:
            "600" // Light snow
        case 616...620:
            "601" // Snow
        case 621...622:
            "602" // Heavy snow
        case 701...780:
            "741" // Fog
        case 781:
            "781" // Tornado
        case 801:
            "801" // Few clouds: 11-25%
        case 802:
            "802" // Scattered clouds: 25-50%
        case 803:
            "803" // Broken clouds: 51-84%
        case 804:
            "804" // Overcast clouds: 85-100%
        default:
            "800" // Clear sky
        }
    }

    init(weatherResponse: WeatherResponse) {
        cityName = weatherResponse.name
        timeZone = weatherResponse.timezone
        conditionName = weatherResponse.weather[0].main
        temperature = weatherResponse.main.temp
        conditionId = weatherResponse.weather[0].id
    }
}
