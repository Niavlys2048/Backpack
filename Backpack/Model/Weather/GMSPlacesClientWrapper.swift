//
//  GMSPlacesClientWrapper.swift
//  Backpack
//
//  Created by Sylvain Druaux on 07/02/2023.
//

import Foundation
import GooglePlaces

class GMSPlacesClientWrapper {
    // MARK: - Properties

    static let shared = GMSPlacesClientWrapper()

    private let client = GMSPlacesClient.shared()

    // MARK: - Type Alias

    typealias GMSAutocompletePredictionCallbackWrapper = ([GMSAutocompletePredictionProtocol]?, Error?) -> Void
    typealias GMSPlaceResultCallbackWrapper = (GMSPlaceProtocol?, Error?) -> Void

    // MARK: - Methods

    init() {} // Not private for the unit tests

    func findAutocompletePredictions(
        fromQuery: String,
        filter: GMSAutocompleteFilter,
        sessionToken: GMSAutocompleteSessionToken?,
        callback: @escaping GMSAutocompletePredictionCallbackWrapper
    ) {
        client.findAutocompletePredictions(fromQuery: fromQuery, filter: filter, sessionToken: nil, callback: callback)
    }

    func fetchPlace(fromPlaceID: String, placeFields: GMSPlaceField, sessionToken: GMSAutocompleteSessionToken?, callback: @escaping GMSPlaceResultCallbackWrapper) {
        client.fetchPlace(fromPlaceID: fromPlaceID, placeFields: placeFields, sessionToken: nil, callback: callback)
    }
}
