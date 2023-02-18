//
//  FakeWeatherResponseData.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 06/02/2023.
//

import Foundation

class WeatherResponseDataFake {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class WeatherError: Error {}
    static let error = WeatherError()
    
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: WeatherResponseDataFake.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            return Data()
        }
    }
    
    static let weatherIncorrectData = "incorrect data".data(using: .utf8)!
}
