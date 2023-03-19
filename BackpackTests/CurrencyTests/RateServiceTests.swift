//
//  RateServiceTests.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 09/02/2023.
//

@testable import Backpack
import XCTest

final class RateServiceTests: XCTestCase {
    func test_performRequest_Failed_Error() {
        // Given
        let rateService = RateService(session: URLSessionFake(data: nil, response: nil, error: RatesResponseDataFake.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        rateService.performRequest { result in
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
        let rateService = RateService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        rateService.performRequest { result in
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
        let rateService = RateService(
            session: URLSessionFake(
                data: RatesResponseDataFake.ratesCorrectData,
                response: RatesResponseDataFake.responseKO, error: nil
            )
        )
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        rateService.performRequest { result in
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
        let rateService = RateService(
            session: URLSessionFake(
                data: RatesResponseDataFake.ratesIncorrectData,
                response: RatesResponseDataFake.responseOK, error: nil
            )
        )
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        rateService.performRequest { result in
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
        let rateService = RateService(
            session: URLSessionFake(
                data: RatesResponseDataFake.ratesCorrectData,
                response: RatesResponseDataFake.responseOK, error: nil
            )
        )
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        rateService.performRequest { result in
            // Then
            
            let aedCurrencyCode = "AED"
            let aedCurrencyRate = 3.67306

            let audCurrencyCode = "AUD"
            let audCurrencyRate = 1.433599
            
            let brlCurrencyCode = "BRL"
            let brlCurrencyRate = 5.201401
            
            let cadCurrencyCode = "CAD"
            let cadCurrencyRate = 1.340375
            
            switch result {
            case .success(let rateModels):
                let sortedRates = rateModels.sorted { $0.currencyCode < $1.currencyCode }
                
                XCTAssertEqual(aedCurrencyCode, sortedRates[0].currencyCode)
                XCTAssertEqual(aedCurrencyRate, sortedRates[0].currencyRate)
                
                XCTAssertEqual(audCurrencyCode, sortedRates[1].currencyCode)
                XCTAssertEqual(audCurrencyRate, sortedRates[1].currencyRate)
                
                XCTAssertEqual(brlCurrencyCode, sortedRates[2].currencyCode)
                XCTAssertEqual(brlCurrencyRate, sortedRates[2].currencyRate)
                
                XCTAssertEqual(cadCurrencyCode, sortedRates[3].currencyCode)
                XCTAssertEqual(cadCurrencyRate, sortedRates[3].currencyRate)
            case .failure:
                XCTFail(#function)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
