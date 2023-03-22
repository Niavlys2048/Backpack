//
//  RestAPIClient.swift
//  Backpack
//
//  Created by Sylvain Druaux on 18/03/2023.
//

import Foundation

enum DataError: Error {
    case connectionFailed
    case requestFailed(error: Error)
    case invalidResponse
    case unsuccessfulResponse(statusCode: Int)
    case noData
    case decodingFailed(error: Error)
}

final class RestAPIClient {
    static var shared = RestAPIClient()
    
    private var task: URLSessionTask?
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    private init() { }
    
    func fetchData<T: Decodable>(route: APIRouter, completion: @escaping(Result<T, DataError>) -> Void) {
        // Create a request from the API router
        guard let request = try? route.asURLRequest() else {
            completion(.failure(.connectionFailed))
            return
        }
        
        // Cancel the previous task if another request happens
        task?.cancel()
        
        // Create a URLSessionDataTask to send the request
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                // Check for errors
                if let error = error {
                    completion(.failure(.requestFailed(error: error)))
                    return
                }
                
                // Check for a response
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                // Check for a successful response
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.unsuccessfulResponse(statusCode: httpResponse.statusCode)))
                    return
                }
                
                // Check for data
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    // Decode the data to the specified type
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingFailed(error: error)))
                }
            }
        }
        task.resume()
    }
}
