//
//  WeatherManager.swift
//  Backpack
//
//  Created by Sylvain Druaux on 31/01/2023.
//

// https://openweathermap.org/current

import Foundation

final class WeatherManager {
    
    // MARK: - Properties
    // shared represents unique instance of the class
    static var shared = WeatherManager()
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather/"
    private var task: URLSessionTask?
    
    // Dependency injection (for unit tests)
    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Methods
    // Make init private to become inaccessible from outside
    private init() {}
    
    func performRequest(coordinates: Coordinates, callback: @escaping (Bool, WeatherModel?) -> Void) {        
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String
        
        guard let apiKey, !apiKey.isEmpty else {
            print("Error: Missing OpenWeather API key")
            return
        }
        
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        
        let urlString = "\(weatherURL)?appid=\(apiKey)&units=metric&lat=\(latitude)&lon=\(longitude)"
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            
            // 2. Create URLSession (see Dependency injection for unit tests)
            
            // Cancel the previous task if a new request is added before the previous task is completed
            task?.cancel()
            
            // 3. Give the session a task
            task = session.dataTask(with: url, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    guard let safeData = data, error == nil else {
                        callback(false, nil)
                        return
                    }
                    
                    guard let safeResponse = response as? HTTPURLResponse, safeResponse.statusCode == 200 else {
                        callback(false, nil)
                        return
                    }
                    
                    guard let weather = self.parseJSON(safeData) else {
                        callback(false, nil)
                        return
                    }
                    
                    callback(true, weather)
                }
            })
        }
        
        // 4. Start the task
        task?.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let city = decodedData.name
            let timeZone = decodedData.timezone
            let conditionName = decodedData.weather[0].main
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(cityName: city, timeZone: timeZone, conditionName: conditionName, temperature: temp, conditionId: id)
            return weather
        } catch {
            return nil
        }
    }
}
