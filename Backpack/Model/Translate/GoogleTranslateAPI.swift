//
//  GoogleTranslateAPI.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import Foundation

enum GoogleTranslateAPI {
    case translate
    case supportedLanguages
    
    func getURL() -> String {
        lazy var appConfiguration = AppConfiguration()
        var urlString = ""
        
        switch self {
        case .translate:
            urlString = appConfiguration.googleTranslateBaseURL
        
        case .supportedLanguages:
            urlString = appConfiguration.googleLanguagesBaseURL
        }
        return urlString
    }
    
    func getHTTPMethod() -> String {
        if self == .supportedLanguages {
            return "GET"
        } else {
            return "POST"
        }
    }
}
