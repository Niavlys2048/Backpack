//
//  GMSProtocols.swift
//  Backpack
//
//  Created by Sylvain Druaux on 11/02/2023.
//

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
