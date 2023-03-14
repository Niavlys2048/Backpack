//
//  RateManager.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

import Foundation

final class RateManager {
    
    // MARK: - Properties
    static var shared = RateManager()
    private let currencyCodes = CurrencyCodes.mainCurrencyCodes.joined(separator: ",")
    private var task: URLSessionTask?
    private var session = URLSession(configuration: .default)
    
    lazy var appConfiguration = AppConfiguration()
    private var apiKey: String?
    
    // MARK: - Enum
    enum RateError: Error {
        case failedToConnect, failedToGetRates, failedToParseRates
    }
    
    // MARK: - Methods
    init(session: URLSession) {
        self.session = session
    }
    
    private init() {
        apiKey = appConfiguration.fixerApiKey
    }
    
    func performRequest(completion: @escaping (Result<[RateModel], Error>) -> Void) {
        var urlParams = [String: String]()
        urlParams["apikey"] = apiKey
        urlParams["base"] = "USD"
        urlParams["symbols"] = currencyCodes
        
        // 1. Retrieve url
        guard var components = URLComponents(string: appConfiguration.fixerBaseURL) else {
            completion(.failure(RateError.failedToConnect))
            return
        }
        
        // 2. Building final url with all parameters
        components.queryItems = [URLQueryItem]()
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        // 3. Create final url
        guard let url = components.url else {
            completion(.failure(RateError.failedToConnect))
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
                    completion(.failure(RateError.failedToConnect))
                    return
                }
                
                guard let safeResponse = response as? HTTPURLResponse, safeResponse.statusCode == 200 else {
                    completion(.failure(RateError.failedToGetRates))
                    return
                }
                
                guard let rates = self.parseJSON(safeData) else {
                    completion(.failure(RateError.failedToParseRates))
                    return
                }
                completion(.success(rates))
            }
        })
        
        // 7. Start the task
        task?.resume()
    }
    
    private func parseJSON(_ rateData: Data) -> [RateModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RateData.self, from: rateData)
            
            var rates: [RateModel] = []
            for row in decodedData.rates {
                let rate = RateModel(currencyCode: row.key, currencyRate: row.value)
                rates.append(rate)
            }

            return rates
        } catch {
            return nil
        }
    }
}
