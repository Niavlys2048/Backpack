//
//  CurrencyDataFake.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 13/02/2023.
//

@testable import Backpack
import Foundation

class CurrencyDataFake {
    private var availableCurrencyData: [Currency] = []
    var currencyData: [Currency] = []
    private var rates: [String: Double] = ["EUR": 0.92872, "USD": 1, "GBP": 0.823361, "JPY": 130.788502]
    
    private func initAvailableCurrencyData() {
        let localeIDs = Locale.availableIdentifiers
        
        for localeID in localeIDs {
            let locale = Locale(identifier: localeID)
            let currencyCode = locale.currencyCode
            if let currencyCode, CurrencyCodes.mainCurrencyCodes.contains(currencyCode), !availableCurrencyData.contains(where: {
                $0.code == currencyCode }
            ) {
                let currency = Currency(countryId: localeID)
                availableCurrencyData.append(currency)
            }
        }
    }
    
    private func updateRates() {
        for currency in self.currencyData {
            for rate in rates where currency.code == rate.key {
                currency.rate = rate.value
            }
        }
    }
    
    private func initCurrencyData() {
        let startingCurrencyList = ["EUR", "USD", "GBP", "JPY"]
        currencyData = availableCurrencyData.filter { currency in
            return startingCurrencyList.contains(currency.code)
        }
    }
        
    init() {
        initAvailableCurrencyData()
        initCurrencyData()
        updateRates()
    }
}
