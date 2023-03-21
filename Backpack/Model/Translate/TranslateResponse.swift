//
//  TranslateResponse.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import Foundation

struct TranslateResponse: Codable {
    let data: Translations
}

struct Translations: Codable {
    var translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
    let detectedSourceLanguage: String
}
