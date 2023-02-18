//
//  GMSProtocols.swift
//  Backpack
//
//  Created by Sylvain Druaux on 11/02/2023.
//

// https://developers.google.com/maps/documentation/places/ios-sdk/reference/interface_g_m_s_autocomplete_prediction
// https://developers.google.com/maps/documentation/places/ios-sdk/reference/interface_g_m_s_place

import Foundation
import GooglePlaces

// MARK: - GMSAutocompletePrediction Protocol
protocol GMSAutocompletePredictionProtocol {
    var attributedFullText: NSAttributedString { get }
    var placeID: String { get }
}

extension GMSAutocompletePrediction: GMSAutocompletePredictionProtocol {}

// MARK: - GMSPlace Protocol
protocol GMSPlaceProtocol {
    var coordinate: CLLocationCoordinate2D { get }
}

extension GMSPlace: GMSPlaceProtocol {}
