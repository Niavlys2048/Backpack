//
//  GooglePlacesManager.swift
//  Backpack
//
//  Created by Sylvain Druaux on 29/01/2023.
//

// https://developers.google.com/maps/documentation/places/ios-sdk/config#use-cocoapods
// https://developers.google.com/maps/documentation/places/ios-sdk/autocomplete

import Foundation
import GooglePlaces

// MARK: - Structs (Global)
struct Place {
    let name: String
    let identifier: String
}

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

final class GooglePlacesManager {
    
    // MARK: - Properties
    static let shared = GooglePlacesManager()
    
//    private let client = GMSPlacesClient.shared()
    private var client = GMSPlacesClientWrapper.shared
    
    // MARK: - Enum
    enum PlacesError: Error {
        case failedToFind, failedToGetCoordinates
    }
    
    // MARK: - Methods
    init(client: GMSPlacesClientWrapper) {
        self.client = client
    }
    
    private init() {}
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        // https://developers.google.com/maps/documentation/places/ios-sdk/supported_types
        filter.types = ["locality"]
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string, identifier: $0.placeID)
            })
            completion(.success(places))
        }
    }
    
    public func resolveLocation(for place: Place, completion: @escaping (Result<Coordinates, Error>) -> Void) {
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            
            let coordinates = Coordinates(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(coordinates))
        }
    }
}
