//
//  TranslateService.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import Foundation

final class TranslateService {
    
    // MARK: - Properties
    static var shared = TranslateService()
    
    private var restAPIClient: RestAPIClient
    
    init(restAPIClient: RestAPIClient = .shared) {
        self.restAPIClient = restAPIClient
    }
    
    func getTranslation(textToTranslate: String, targetLanguage: String, completion: @escaping(Result<TranslateResponse, DataError>) -> Void) {
        restAPIClient.getTranslation(textToTranslate: textToTranslate, targetLanguage: targetLanguage, completion: completion)
    }
    
    func getLanguages(completion: @escaping(Result<LanguageResponse, DataError>) -> Void) {
        restAPIClient.getLanguages(completion: completion)
    }
}
