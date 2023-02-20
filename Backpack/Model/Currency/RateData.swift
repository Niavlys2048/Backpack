//
//  RateData.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

import Foundation

struct RateData: Decodable {
    let rates: [String: Double]
}
