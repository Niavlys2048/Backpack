//
//  GMSAutocompletePredictionMock.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 09/02/2023.
//

// https://developers.google.com/maps/documentation/places/ios-sdk/reference/interface_g_m_s_autocomplete_prediction

@testable import Backpack
import Foundation

struct GMSAutocompletePredictionMock: GMSAutocompletePredictionProtocol {
    let placeID: String
    let attributedFullText: NSAttributedString
    
    init(placeID: String, attributedFullText: NSAttributedString) {
        self.placeID = placeID
        self.attributedFullText = attributedFullText
    }
}

extension GMSAutocompletePredictionMock {
    static var mock: GMSAutocompletePredictionMock {
        .init(
            placeID: "ChIJN1t_tDeuEmsRUsoyG83frY4",
            attributedFullText: .init(string: "San Francisco, CA, USA")
        )
    }
}
