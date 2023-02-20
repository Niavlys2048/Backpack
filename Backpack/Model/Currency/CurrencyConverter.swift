//
//  CurrencyConverter.swift
//  Backpack
//
//  Created by Sylvain Druaux on 08/02/2023.
//

// https://www.jessesquires.com/blog/2022/02/01/decimal-vs-double/

import Foundation

final class CurrencyConverter {
    func convertCurrency(amount: String, selectedCurrency: Currency, currencyArray: [Currency]) -> [Currency] {
        guard !amount.isEmpty else {
            for currency in currencyArray {
                currency.amount = (0).displayCurrency
            }
            return currencyArray
        }
        
        // Setting the separator var ("." or "," based on locale)
        let numberFormatter = NumberFormatter()
        let decimalSeparator = numberFormatter.locale.decimalSeparator ?? "."
        
        guard let amountDecimal = amount.toDecimal else {
            return currencyArray
        }
        
        // Reformat amount to match the input (hidden TextField)
        let amountSplit = amount.components(separatedBy: decimalSeparator)
        if !amount.contains(decimalSeparator) {
            // Example: 5000 > 5,000 for en_US locale, 5 000 for fr_FR locale
            selectedCurrency.amount = String(amountDecimal.displayCurrency.dropLast(3))
        } else if amount.last == Character(decimalSeparator) {
            // Example: 5000. > 5,000. for en_US locale, 5 000, for fr_FR locale
            selectedCurrency.amount = String(amountDecimal.displayCurrency.dropLast(2))
        } else if amount.contains(decimalSeparator), amountSplit[1].count == 1 {
            // Example: 5000.2 > 5,000.2 for en_US locale, 5 000,2 for fr_FR locale
            selectedCurrency.amount = String(amountDecimal.displayCurrency.dropLast())
        } else {
            selectedCurrency.amount = amountDecimal.displayCurrency
        }
        
        let selectedCurrencyRateDecimal = Decimal(selectedCurrency.rate)
        let factorDecimal = amountDecimal / selectedCurrencyRateDecimal
        
        for currency in currencyArray where currency.code != selectedCurrency.code {
            let currencyRateDecimal = Decimal(currency.rate)
            let currencyAmountDecimal = currencyRateDecimal * factorDecimal
            currency.amount = currencyAmountDecimal.displayCurrency
        }
        return currencyArray
    }
    
    func updateAmount(currencyArray: [Currency]) -> [Currency] {
        let dollarAmount = currencyArray.filter({ $0.code == "USD" }).map({ return $0.amount })[0]
        guard let dollarAmountDecimal = dollarAmount.toDecimal else {
            return currencyArray
        }
        for currency in currencyArray where currency.code != "USD" {
            let currencyRateDecimal = Decimal(currency.rate)
            let currencyAmountDecimal = currencyRateDecimal * dollarAmountDecimal
            currency.amount = currencyAmountDecimal.displayCurrency
        }
        return currencyArray
    }
}
