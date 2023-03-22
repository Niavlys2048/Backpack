//
//  WeatherServiceTests.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 06/02/2023.
//

@testable import Backpack
import XCTest

final class WeatherServiceTests: XCTestCase {
    func test_performRequest_Failed_Error() {
        // Given
        let restAPIClient = RestAPIClient(session: URLSessionFake(data: nil, response: nil, error: WeatherResponseDataFake.error))
        let weatherService = WeatherService(restAPIClient: restAPIClient)
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(coordinates: parisCoordinates) { result in
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
    
    func test_performRequest_Failed_WithoutData() {
        // Given
        let restAPIClient = RestAPIClient(session: URLSessionFake(data: nil, response: nil, error: nil))
        let weatherService = WeatherService(restAPIClient: restAPIClient)
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(coordinates: parisCoordinates) { result in
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
    
    func test_performRequest_Failed_InccorectResponse() {
        // Given
        let restAPIClient = RestAPIClient(
            session: URLSessionFake(
                data: WeatherResponseDataFake.weatherCorrectData,
                response: WeatherResponseDataFake.responseKO, error: nil
            )
        )
        let weatherService = WeatherService(restAPIClient: restAPIClient)
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(coordinates: parisCoordinates) { result in
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
    
    func test_performRequest_Failed_InccorectData() {
        // Given
        let restAPIClient = RestAPIClient(
            session: URLSessionFake(
                data: WeatherResponseDataFake.weatherIncorrectData,
                response: WeatherResponseDataFake.responseOK, error: nil
            )
        )
        let weatherService = WeatherService(restAPIClient: restAPIClient)
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(coordinates: parisCoordinates) { result in
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
    
    func test_performRequest_Success_CorrectData() {
        // Given
        let restAPIClient = RestAPIClient(
            session: URLSessionFake(
                data: WeatherResponseDataFake.weatherCorrectData,
                response: WeatherResponseDataFake.responseOK, error: nil
            )
        )
        let weatherService = WeatherService(restAPIClient: restAPIClient)
        let parisCoordinates = Coordinates(latitude: 48.8566, longitude: 2.3522)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(coordinates: parisCoordinates) { result in
            // Then
            let cityName = "Paris"
            let timeZone = 3600
            let conditionName = "Clear"
            let temperature = 5.99
            let conditionId = 800
            
            switch result {
            case .success(let weatherResponse):
                let weatherModel = WeatherModel(weatherResponse: weatherResponse)
                XCTAssertEqual(cityName, weatherModel.cityName)
                XCTAssertEqual(timeZone, weatherModel.timeZone)
                XCTAssertEqual(conditionName, weatherModel.conditionName)
                XCTAssertEqual(temperature, weatherModel.temperature)
                XCTAssertEqual(conditionId, weatherModel.conditionId)
            case .failure:
                XCTFail(#function)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
