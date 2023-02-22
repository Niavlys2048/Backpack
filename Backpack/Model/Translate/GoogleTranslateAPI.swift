//
//  GoogleTranslateAPI.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

// https://cloud.google.com/translate/docs/basic/translating-text
// https://cloud.google.com/translate/docs/basic/discovering-supported-languages
// https://developerinsider.co/advanced-enum-enumerations-by-example-swift-programming-language/

import Foundation

enum GoogleTranslateAPI {
    case translate
    case supportedLanguages
    
    func getURL() -> String {
        var urlString = ""
        
        switch self {
        case .translate:
            urlString = "https://translation.googleapis.com/language/translate/v2"
        
        case .supportedLanguages:
            urlString = "https://translation.googleapis.com/language/translate/v2/languages"
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
