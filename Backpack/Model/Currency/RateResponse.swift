//
//  RateResponse.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

import Foundation

struct RateResponse: Decodable {
    let rates: [String: Double]
}
