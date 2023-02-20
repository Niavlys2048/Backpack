//
//  Currency.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

import Foundation

final class Currency {
    let countryId: String
    let code: String
    let name: String
    let symbol: String
    let countryCode: String
    var rate: Double = 0.0
    var amount: String = (0).displayCurrency
    
    init(countryId: String) {
        self.countryId = countryId
        let locale = Locale(identifier: countryId)
        self.code = locale.currencyCode ?? ""
        self.symbol = locale.currencySymbol ?? ""
        switch code {
        case "EUR": // For all Euro Member Countries
            self.countryCode = "EU"
        case "AUD": // Fix a bug from Locale giving the wrong country code
            self.countryCode = "AU"
        default:
            self.countryCode = locale.regionCode ?? ""
        }
        self.name = (code == "EUR") ? "Euro Member Countries" : Locale.current.localizedString(forCurrencyCode: code) ?? ""
    }
}
