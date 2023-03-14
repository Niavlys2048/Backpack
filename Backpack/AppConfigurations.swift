//
//  AppConfigurations.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/03/2023.
//

import Foundation

final class AppConfiguration {
    
    lazy var fixerApiKey: String = {
        guard let fixerApiKey = Bundle.main.object(forInfoDictionaryKey: "FIXER_API_KEY") as? String else {
            fatalError("Missing Fixer API Key")
        }
        return fixerApiKey
    }()
    lazy var googleApiKey: String = {
        guard let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String else {
            fatalError("Missing Goolge API Key")
        }
        return googleApiKey
    }()
    lazy var openWeatherApiKey: String = {
        guard let openWeatherApiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String else {
            fatalError("Missing OpenWeather API Key")
        }
        return openWeatherApiKey
    }()
    
    lazy var fixerBaseURL: String = {
        guard let fixerBaseURL = Bundle.main.object(forInfoDictionaryKey: "FIXER_BASE_URL") as? String else {
            fatalError("FIXER_BASE_URL must not be empty in plist")
        }
        return fixerBaseURL
    }()
    lazy var googleTranslateBaseURL: String = {
        guard let googleTranslateBaseURL = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_TRANSLATE_BASE_URL") as? String else {
            fatalError("GOOGLE_TRANSLATE_BASE_URL must not be empty in plist")
        }
        return googleTranslateBaseURL
    }()
    lazy var googleLanguagesBaseURL: String = {
        guard let googleLanguagesBaseURL = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_LANGUAGES_BASE_URL") as? String else {
            fatalError("GOOGLE_LANGUAGES_BASE_URL must not be empty in plist")
        }
        return googleLanguagesBaseURL
    }()
    lazy var openWeatherBaseURL: String = {
        guard let openWeatherBaseURL = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_BASE_URL") as? String else {
            fatalError("OPEN_WEATHER_BASE_URL must not be empty in plist")
        }
        return openWeatherBaseURL
    }()
}
