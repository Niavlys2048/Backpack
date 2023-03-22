//
//  LanguageResponse.swift
//  Backpack
//
//  Created by Sylvain Druaux on 15/02/2023.
//

import Foundation

struct LanguageResponse: Decodable {
    let data: Languages
}

struct Languages: Decodable {
    var languages: [Language]
}

struct Language: Decodable {
    let language: String
    let name: String
}
