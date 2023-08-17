//
//  GMSAutocompletePredictionMock.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 09/02/2023.
//

@testable import Backpack
import Foundation

struct GMSAutocompletePredictionMock: GMSAutocompletePredictionProtocol {
    let placeID: String
    let attributedFullText: NSAttributedString
}

extension GMSAutocompletePredictionMock {
    static var mock: GMSAutocompletePredictionMock {
        .init(
            placeID: "ChIJN1t_tDeuEmsRUsoyG83frY4",
            attributedFullText: .init(string: "San Francisco, CA, USA")
        )
    }
}
