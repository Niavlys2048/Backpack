//
//  WeatherService.swift
//  Backpack
//
//  Created by Sylvain Druaux on 31/01/2023.
//

import Foundation

class WeatherService {
    static let shared = WeatherService()
    
    private var restAPIClient: RestAPIClient?
    
    init(restAPIClient: RestAPIClient) {
        self.restAPIClient = restAPIClient
    }
    
    private init() { }
    
    func getWeather(coordinates: Coordinates, completion: @escaping(Result<WeatherResponse, DataError>) -> Void) {
        if let restAPIClient {
            restAPIClient.getWeather(coordinates: coordinates, completion: completion)
        } else {
            RestAPIClient.shared.getWeather(coordinates: coordinates, completion: completion)
        }
    }
}
