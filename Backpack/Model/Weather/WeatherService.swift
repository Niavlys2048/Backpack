//
//  WeatherService.swift
//  Backpack
//
//  Created by Sylvain Druaux on 31/01/2023.
//

import Foundation

class WeatherService {
    static var shared = WeatherService()
    
    private var restAPIClient: RestAPIClient
    
    init(restAPIClient: RestAPIClient = .shared) {
        self.restAPIClient = restAPIClient
    }
    
    func getWeather(coordinates: Coordinates, completion: @escaping(Result<WeatherResponse, DataError>) -> Void) {
        let latitude = String(coordinates.latitude)
        let longitude = String(coordinates.longitude)
        return restAPIClient.fetchData(route: .getWeather(latitude: latitude, longitude: longitude), completion: completion)
    }
}
