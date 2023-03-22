//
//  RatesModel.swift
//  Backpack
//
//  Created by Sylvain Druaux on 04/02/2023.
//

import Foundation

struct RatesModel {
    var rates: [RateModel]
    
    init(rateResponse: RateResponse) {
        rates = [RateModel]()
        let ratesData = rateResponse.rates
        for rate in ratesData {
            let rateModel = RateModel(currencyCode: rate.key, currencyRate: rate.value)
            rates.append(rateModel)
        }
    }
}

struct RateModel {
    let currencyCode: String
    let currencyRate: Double
}
