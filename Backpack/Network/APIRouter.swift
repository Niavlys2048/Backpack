//
//  APIRouter.swift
//  Backpack
//
//  Created by Sylvain Druaux on 18/03/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}

enum APIRouter {
    case getWeather(latitude: String, longitude: String)
    case getRates
    case getTranslation(textToTranslate: String, targetLanguage: String)
    case getLanguages

    private var urlPath: String {
        switch self {
        case .getWeather:
            AppConfiguration.shared.openWeatherBaseURL
        case .getRates:
            AppConfiguration.shared.fixerBaseURL
        case .getTranslation:
            AppConfiguration.shared.googleTranslateBaseURL
        case .getLanguages:
            AppConfiguration.shared.googleLanguagesBaseURL
        }
    }

    private var parameters: [String: String] {
        var urlParams = [String: String]()
        switch self {
        case .getWeather(let latitude, let longitude):
            urlParams["appid"] = AppConfiguration.shared.openWeatherApiKey
            urlParams["units"] = "metric"
            urlParams["lat"] = latitude
            urlParams["lon"] = longitude
            return urlParams
        case .getRates:
            urlParams["access_key"] = AppConfiguration.shared.fixerApiKey
//            urlParams["base"] = CurrencyCodes.usDollar
//            urlParams["symbols"] = CurrencyCodes.mainCurrencies.joined(separator: ",")
            return urlParams
        case .getTranslation(let textToTranslate, let targetLanguage):
            urlParams["key"] = AppConfiguration.shared.googleApiKey
            urlParams["q"] = textToTranslate
            urlParams["target"] = targetLanguage
            return urlParams
        case .getLanguages:
            urlParams["key"] = AppConfiguration.shared.googleApiKey
            urlParams["target"] = Locale.current.languageCode ?? "en"
            return urlParams
        }
    }

    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: urlPath) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        let urlRequest = URLRequest(url: url)

        return urlRequest
    }
}
