//
//  TranslateResponseDataFake.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 15/02/2023.
//

import Foundation

class TranslateResponseDataFake {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://translation.googleapis.com/language/translate/v2")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://translation.googleapis.com/language/translate/v2")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class TranslateError: Error {}
    static let error = TranslateError()
    
    static var translateCorrectData: Data {
        let bundle = Bundle(for: TranslateResponseDataFake.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            return Data()
        }
    }
    
    static let translateIncorrectData = "incorrect data".data(using: .utf8)!
}
