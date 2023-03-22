//
//  RateService.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

import Foundation

final class RateService {
    
    // MARK: - Properties
    static var shared = RateService()
    
    private var restAPIClient: RestAPIClient
    
    init(restAPIClient: RestAPIClient = .shared) {
        self.restAPIClient = restAPIClient
    }
    
    func getRates(completion: @escaping(Result<RateResponse, DataError>) -> Void) {
        return restAPIClient.fetchData(route: .getRates, completion: completion)
    }
}
