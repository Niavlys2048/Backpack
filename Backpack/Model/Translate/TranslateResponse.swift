//
//  TranslateResponse.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import Foundation

struct TranslateResponse: Decodable {
    let data: Translations
}

struct Translations: Decodable {
    var translations: [Translation]
}

struct Translation: Decodable {
    let translatedText: String
    let detectedSourceLanguage: String
}
