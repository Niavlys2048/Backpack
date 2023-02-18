//
//  WeatherManagerTests.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 06/02/2023.
//

@testable import Backpack
import XCTest

final class WeatherManagerTests: XCTestCase {
    func test_performRequest_Failed_Error() {
        // Given
        let weatherManager = WeatherManager(session: URLSessionFake(data: nil, response: nil, error: WeatherResponseDataFake.error))
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherManager.performRequest(coordinates: parisCoordinates) { success, weatherModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_performRequest_Failed_WithoutData() {
        // Given
        let weatherManager = WeatherManager(session: URLSessionFake(data: nil, response: nil, error: nil))
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherManager.performRequest(coordinates: parisCoordinates) { success, weatherModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_performRequest_Failed_InccorectResponse() {
        // Given
        let weatherManager = WeatherManager(
            session: URLSessionFake(
                data: WeatherResponseDataFake.weatherCorrectData,
                response: WeatherResponseDataFake.responseKO, error: nil
            )
        )
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherManager.performRequest(coordinates: parisCoordinates) { success, weatherModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_performRequest_Failed_InccorectData() {
        // Given
        let weatherManager = WeatherManager(
            session: URLSessionFake(
                data: WeatherResponseDataFake.weatherIncorrectData,
                response: WeatherResponseDataFake.responseOK, error: nil
            )
        )
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherManager.performRequest(coordinates: parisCoordinates) { success, weatherModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_performRequest_Success_CorrectData() {
        // Given
        let weatherManager = WeatherManager(
            session: URLSessionFake(
                data: WeatherResponseDataFake.weatherCorrectData,
                response: WeatherResponseDataFake.responseOK, error: nil
            )
        )
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherManager.performRequest(coordinates: parisCoordinates) { success, weatherModel in
            // Then
            let cityName = "Paris"
            let timeZone = 3600
            let conditionName = "Clear"
            let temperature = 5.99
            let conditionId = 800
            
            XCTAssertTrue(success)
            XCTAssertNotNil(weatherModel)
            
            XCTAssertEqual(cityName, weatherModel?.cityName)
            XCTAssertEqual(timeZone, weatherModel?.timeZone)
            XCTAssertEqual(conditionName, weatherModel?.conditionName)
            XCTAssertEqual(temperature, weatherModel?.temperature)
            XCTAssertEqual(conditionId, weatherModel?.conditionId)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
