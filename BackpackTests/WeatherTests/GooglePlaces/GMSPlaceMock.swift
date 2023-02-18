//
//  GMSPlaceMock.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 12/02/2023.
//

@testable import Backpack
import Foundation
import CoreLocation

struct GMSPlaceMock: GMSPlaceProtocol {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

extension GMSPlaceMock {
    static var mock: GMSPlaceMock {
        .init(
            // Coordinate of San Francisco, CA, USA
            coordinate: CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
        )
    }
}
