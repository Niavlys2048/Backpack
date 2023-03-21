//
//  LanguageResponse.swift
//  Backpack
//
//  Created by Sylvain Druaux on 15/02/2023.
//

import Foundation

struct LanguageResponse: Codable {
    let data: Languages
}

struct Languages: Codable {
    var languages: [Language]
}

struct Language: Codable {
    let language: String
    let name: String
}
