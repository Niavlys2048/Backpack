//
//  RateManager.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

// https://fixer.io/documentation

import Foundation

final class RateManager {
    
    // MARK: - Properties
    // shared represents unique instance of the class
    static var shared = RateManager()
    
    private let currencieCodes = mainCurrencyCodes.joined(separator: ",")
    
    private let ratesURL = "https://api.apilayer.com/fixer/latest"
    private var task: URLSessionTask?    
    
    // Dependency injection (for unit tests)
    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Methods
    // Make init private to become inaccessible from outside
    private init() {}
    
    func performRequest(callback: @escaping (Bool, [RateModel]?) -> Void) {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "FIXER_API_KEY") as? String
        
        guard let apiKey, !apiKey.isEmpty else {
            print("Error: Missing fixer API key")
            return
        }
        
        let urlString = "\(ratesURL)?base=USD&apikey=\(apiKey)&symbols=\(currencieCodes)"
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            
            // 2. Create URLSession
//            let session = URLSession(configuration: .default)
            
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
                    
                    guard let rates = self.parseJSON(safeData) else {
                        callback(false, nil)
                        return
                    }
                    
                    callback(true, rates)
                }
            })
        }
        
        // 4. Start the task
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
