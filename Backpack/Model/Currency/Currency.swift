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
    var amount: String = 0.displayCurrency

    init(countryId: String) {
        self.countryId = countryId
        let locale = Locale(identifier: countryId)
        code = locale.currencyCode ?? ""
        symbol = locale.currencySymbol ?? ""
        switch code {
        case CurrencyCodes.euro: // For all Euro Member Countries
            countryCode = "EU"
        default:
            countryCode = String(code.prefix(2))
        }
        name = (code == CurrencyCodes.euro) ? "Euro Member Countries" : Locale.current.localizedString(forCurrencyCode: code) ?? ""
    }
}
