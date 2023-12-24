//
//  RatesResponseDataFake.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 09/02/2023.
//

import Foundation

class RatesResponseDataFake {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://apilayer.com/")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://apilayer.com/")!, statusCode: 500, httpVersion: nil, headerFields: nil)!

    class RatesError: Error {}
    static let error = RatesError()

    static var ratesCorrectData: Data {
        let bundle = Bundle(for: RatesResponseDataFake.self)
        let url = bundle.url(forResource: "Rates", withExtension: "json")
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            return Data()
        }
    }

    static let ratesIncorrectData = Data("incorrect data".utf8)
}
