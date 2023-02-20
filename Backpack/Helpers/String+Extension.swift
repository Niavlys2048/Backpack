//
//  String+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 11/02/2023.
//

import Foundation

extension String {
    var toDecimal: Decimal? {
        let locale = Locale.autoupdatingCurrent
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: locale.identifier)
        formatter.numberStyle = .decimal
        guard let number = formatter.number(from: self) else {
            return nil
        }
        let decimalValue = number.decimalValue
        return decimalValue
    }
}
