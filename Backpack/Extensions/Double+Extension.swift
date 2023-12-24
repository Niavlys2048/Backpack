//
//  Double+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 01/02/2023.
//

import Foundation

extension Double {
    var displayRoundedToInteger: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .halfUp
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(for: self) ?? String(self)
    }

    var displayCurrency: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(for: self) ?? String(self)
    }
}
