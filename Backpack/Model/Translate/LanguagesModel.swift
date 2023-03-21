//
//  LanguagesModel.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import Foundation

struct LanguagesModel {
    var languages: [LanguageModel]
    
    init(languageResponse: LanguageResponse) {
        languages = [LanguageModel]()
        let languagesData = languageResponse.data.languages
        for language in languagesData {
            let languageModel = LanguageModel(name: language.name, code: language.language)
            languages.append(languageModel)
        }
    }
}

struct LanguageModel {
    let name: String
    let code: String
}
