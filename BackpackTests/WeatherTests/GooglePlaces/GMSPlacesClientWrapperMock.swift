//
//  GMSPlacesClientWrapperMock.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 07/02/2023.
//

@testable import Backpack
import Foundation
import GooglePlaces

class GMSPlacesClientWrapperMock: GMSPlacesClientWrapper {
    var expectedError: Error?
    var expectedAutocompletePredictionResults: [GMSAutocompletePredictionProtocol]?
    var expectedPlaceResult: GMSPlaceProtocol?
    var givenFilterTypes: [String]?

    override func findAutocompletePredictions(
        fromQuery: String,
        filter: GMSAutocompleteFilter,
        sessionToken: GMSAutocompleteSessionToken?,
        callback: @escaping GMSAutocompletePredictionCallbackWrapper
    ) {
        givenFilterTypes = filter.types
        callback(expectedAutocompletePredictionResults, expectedError)
    }

    override func fetchPlace(fromPlaceID: String, placeFields: GMSPlaceField, sessionToken: GMSAutocompleteSessionToken?, callback: @escaping GMSPlaceResultCallbackWrapper) {
        callback(expectedPlaceResult, expectedError)
    }
}
