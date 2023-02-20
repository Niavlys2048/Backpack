//
//  Decimal+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 12/02/2023.
//

// https://www.jessesquires.com/blog/2022/02/01/decimal-vs-double/

import Foundation

extension Decimal {
    var displayCurrency: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(for: self) ?? NSDecimalNumber(decimal: self).stringValue
    }
}
