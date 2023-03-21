//
//  TranslateModel.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import Foundation

struct TranslateModel {
    let translatedText: String
    let detectedSourceLanguage: String
    
    init(translateResponse: TranslateResponse) {
        let translation = translateResponse.data.translations[0]
        self.translatedText = translation.translatedText.html2String
        self.detectedSourceLanguage = translation.detectedSourceLanguage
    }
}
