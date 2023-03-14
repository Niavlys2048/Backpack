//
//  WeatherManager.swift
//  Backpack
//
//  Created by Sylvain Druaux on 31/01/2023.
//

import Foundation

final class WeatherManager {
    
    // MARK: - Properties
    static var shared = WeatherManager()
    private var task: URLSessionTask?
    private var session = URLSession(configuration: .default)
    
    lazy var appConfiguration = AppConfiguration()
    private var apiKey: String?
    
    // MARK: - Enum
    enum WeatherError: Error {
        case failedToConnect, failedToGetWeather, failedToParseWeather
    }
    
    // MARK: - Methods
    init(session: URLSession) {
        self.session = session
    }
    
    private init() {
        apiKey = appConfiguration.openWeatherApiKey
    }
    
    func performRequest(coordinates: Coordinates, completion: @escaping (Result<WeatherModel?, Error>) -> Void) {
        let latitude = String(coordinates.latitude)
        let longitude = String(coordinates.longitude)
        
        var urlParams = [String: String]()
        urlParams["appid"] = apiKey
        urlParams["units"] = "metric"
        urlParams["lat"] = latitude
        urlParams["lon"] = longitude
        
        // 1. Retrieve url
        guard var components = URLComponents(string: appConfiguration.openWeatherBaseURL) else {
            completion(.failure(WeatherError.failedToConnect))
            return
        }
        
        // 2. Building final url with all parameters
        components.queryItems = [URLQueryItem]()
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        // 3. Create final url
        guard let url = components.url else {
            completion(.failure(WeatherError.failedToConnect))
            return
        }
        
        // 4. Create URLRequest
        let request = URLRequest(url: url)
        
        // 5. Create URLSession (see Dependency injection for unit tests)
        
        // Cancel the previous task if another request happens
        task?.cancel()
        
        // 6. Give the session a task
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let safeData = data, error == nil else {
                    completion(.failure(WeatherError.failedToConnect))
                    return
                }
                
                guard let safeResponse = response as? HTTPURLResponse, safeResponse.statusCode == 200 else {
                    completion(.failure(WeatherError.failedToGetWeather))
                    return
                }
                
                guard let weather = self.parseJSON(safeData) else {
                    completion(.failure(WeatherError.failedToGetWeather))
                    return
                }
                completion(.success(weather))
            }
        })
                
        // 7. Start the task
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
