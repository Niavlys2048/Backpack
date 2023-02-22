//
//  LanguageResponseDataFake.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 15/02/2023.
//

import Foundation

class LanguageResponseDataFake {
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://translation.googleapis.com/language/translate/v2/languages")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://translation.googleapis.com/language/translate/v2/languages")!,
        statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class LanguageError: Error {}
    static let error = LanguageError()
    
    static var languageCorrectData: Data {
        let bundle = Bundle(for: LanguageResponseDataFake.self)
        let url = bundle.url(forResource: "Languages", withExtension: "json")
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            return Data()
        }
    }
    
    static let languageIncorrectData = "incorrect data".data(using: .utf8)!
}
