//
//  GooglePlacesManagerTests.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 07/02/2023.
//

@testable import Backpack
import GooglePlaces
import XCTest

final class GooglePlacesManagerTests: XCTestCase {
    enum ErrorMock: Error {
        case dummy
    }
    
    func test_findPlaces_Error() {
        // Given
        let clientWrapperMock = GMSPlacesClientWrapperMock()
        let googlePlacesManager = GooglePlacesManager(client: clientWrapperMock)
        clientWrapperMock.expectedError = ErrorMock.dummy
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        googlePlacesManager.findPlaces(query: "san") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Error")
            case .failure:
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_findPlaces_Success_WithData() {
        // Given
        let clientWrapperMock = GMSPlacesClientWrapperMock()
        let googlePlacesManager = GooglePlacesManager(client: clientWrapperMock)
        let autocompletePredictionMock = GMSAutocompletePredictionMock.mock
        clientWrapperMock.expectedAutocompletePredictionResults = [autocompletePredictionMock]
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        googlePlacesManager.findPlaces(query: "san") { result in
            // Then
            switch result {
            case .success(let places):
                XCTAssertEqual(places.count, 1)
                XCTAssertEqual(places.first?.identifier, autocompletePredictionMock.placeID)
                XCTAssertEqual(places.first?.name, autocompletePredictionMock.attributedFullText.string)
            case .failure:
                XCTFail(#function)
            }
            XCTAssertEqual(clientWrapperMock.givenFilterTypes?.count, 1)
            XCTAssertEqual(clientWrapperMock.givenFilterTypes?.first, "locality")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_findPlaces_Success_WithoutData() {
        // Given
        let clientWrapperMock = GMSPlacesClientWrapperMock()
        let googlePlacesManager = GooglePlacesManager(client: clientWrapperMock)
        clientWrapperMock.expectedAutocompletePredictionResults = []
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        googlePlacesManager.findPlaces(query: "san") { result in
            // Then
            switch result {
            case .success(let places):
                XCTAssertEqual(places.count, 0)
            case .failure:
                XCTFail(#function)
            }
            XCTAssertEqual(clientWrapperMock.givenFilterTypes?.count, 1)
            XCTAssertEqual(clientWrapperMock.givenFilterTypes?.first, "locality")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_resolveLocation_Error() {
        // Given
        let clientWrapperMock = GMSPlacesClientWrapperMock()
        let googlePlacesManager = GooglePlacesManager(client: clientWrapperMock)
        clientWrapperMock.expectedError = ErrorMock.dummy
        let place = Place(name: "San Francisco, CA, USA", identifier: "ChIJN1t_tDeuEmsRUsoyG83frY4")
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        googlePlacesManager.resolveLocation(for: place) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Error")
            case .failure:
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_resolveLocation_Success_WithData() {
        // Given
        let clientWrapperMock = GMSPlacesClientWrapperMock()
        let googlePlacesManager = GooglePlacesManager(client: clientWrapperMock)
        let placeMock = GMSPlaceMock.mock
        clientWrapperMock.expectedPlaceResult = placeMock
        let place = Place(name: "San Francisco, CA, USA", identifier: "ChIJN1t_tDeuEmsRUsoyG83frY4")
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        googlePlacesManager.resolveLocation(for: place) { result in
            // Then
            switch result {
            case .success(let coordinate):
                XCTAssertEqual(coordinate.latitude, placeMock.coordinate.latitude)
                XCTAssertEqual(coordinate.longitude, placeMock.coordinate.longitude)
            case .failure:
                XCTFail(#function)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
