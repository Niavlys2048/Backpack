//
//  AppConfigurations.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/03/2023.
//

import Foundation

final class AppConfiguration {
    static let shared = AppConfiguration()
    
    private func getValue(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
             fatalError("Missing \(key)")
         }
        return value
    }
    
    lazy var fixerApiKey: String = {
        return getValue(forKey: "FIXER_API_KEY")
    }()
    lazy var googleApiKey: String = {
        return getValue(forKey: "GOOGLE_API_KEY")
    }()
    lazy var openWeatherApiKey: String = {
        return getValue(forKey: "OPEN_WEATHER_API_KEY")
    }()
    
    lazy var fixerBaseURL: String = {
        return getValue(forKey: "FIXER_BASE_URL")
    }()
    lazy var googleTranslateBaseURL: String = {
        return getValue(forKey: "GOOGLE_TRANSLATE_BASE_URL")
    }()
    lazy var googleLanguagesBaseURL: String = {
        return getValue(forKey: "GOOGLE_LANGUAGES_BASE_URL")
    }()
    lazy var openWeatherBaseURL: String = {
        return getValue(forKey: "OPEN_WEATHER_BASE_URL")
    }()
}
