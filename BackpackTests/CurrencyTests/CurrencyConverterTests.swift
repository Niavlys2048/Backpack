//
//  CurrencyConverterTests.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 11/02/2023.
//

@testable import Backpack
import XCTest

final class CurrencyConverterTests: XCTestCase {
    var currencyConverter: CurrencyConverter!
    
    let numberFormatter = NumberFormatter()
    var decimalSeparator = ""
    
    override func setUp() {
        super.setUp()
        currencyConverter = CurrencyConverter()
        decimalSeparator = numberFormatter.locale.decimalSeparator ?? "."
    }
    
    func test_convertCurrency_EmptyAmount_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.euro }).first else { return }
        
        let amount = ""
        
        // Then
        let result = currencyConverter.convertCurrency(amount: amount, selectedCurrency: currency, currencyArray: currencyData)
        
        let originalAmounts = currencyData.map { $0.amount }.sorted()
        let resultAmounts = result.map { $0.amount }.sorted()
        
        XCTAssertEqual(resultAmounts, originalAmounts)
    }
    
    func test_convertCurrency_WrongAmount_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.euro }).first else { return }
        
        let amount = "not_a_number"
        
        // Then
        let result = currencyConverter.convertCurrency(amount: amount, selectedCurrency: currency, currencyArray: currencyData)
        
        let originalAmounts = currencyData.map { $0.amount }.sorted()
        let resultAmounts = result.map { $0.amount }.sorted()
        
        XCTAssertEqual(resultAmounts, originalAmounts)
    }
    
    func test_convertCurrency_AmountWithoutSeparator_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.euro }).first else { return }
        
        let amount = "5"
        
        // Then
        let result = currencyConverter.convertCurrency(amount: amount, selectedCurrency: currency, currencyArray: currencyData)
        
        let expectedEURAmount = String((5.0).displayCurrency.dropLast(3))
        let expectedUSDAmount = (5.38375).displayCurrency
        let expectedGBPAmount = (4.43277).displayCurrency
        let expectedJPYAmount = (704.13312).displayCurrency
        
        let expectedAmounts = [
            expectedEURAmount,
            expectedUSDAmount,
            expectedGBPAmount,
            expectedJPYAmount
        ]
        let resultAmounts = result.map { $0.amount }
        XCTAssertEqual(resultAmounts, expectedAmounts)
    }
    
    func test_convertCurrency_AmountWithSeparator_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.euro }).first else { return }
        
        let amount = "5\(decimalSeparator)"
        
        // Then
        let result = currencyConverter.convertCurrency(amount: amount, selectedCurrency: currency, currencyArray: currencyData)
        
        let expectedEURAmount = String((5.0).displayCurrency.dropLast(2))
        let expectedUSDAmount = (5.38375).displayCurrency
        let expectedGBPAmount = (4.43277).displayCurrency
        let expectedJPYAmount = (704.13312).displayCurrency
        
        let expectedAmounts = [
            expectedEURAmount,
            expectedUSDAmount,
            expectedGBPAmount,
            expectedJPYAmount
        ]
        let resultAmounts = result.map { $0.amount }
        XCTAssertEqual(resultAmounts, expectedAmounts)
    }
    
    func test_convertCurrency_AmountWithSeparatorAndOneDecimalDigit_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.euro }).first else { return }
        
        let amount = "5\(decimalSeparator)2"
        
        // Then
        let result = currencyConverter.convertCurrency(amount: amount, selectedCurrency: currency, currencyArray: currencyData)
        
        let expectedEURAmount = String((5.2).displayCurrency.dropLast())
        let expectedUSDAmount = (5.59910).displayCurrency
        let expectedGBPAmount = (4.61008).displayCurrency
        let expectedJPYAmount = (732.2984).displayCurrency
        
        let expectedAmounts = [
            expectedEURAmount,
            expectedUSDAmount,
            expectedGBPAmount,
            expectedJPYAmount
        ]
        let resultAmounts = result.map { $0.amount }
        XCTAssertEqual(resultAmounts, expectedAmounts)
    }
    
    func test_convertCurrency_LargeAmountWithSeparator_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.euro }).first else { return }
        
        let amount = "50000\(decimalSeparator)"
        
        // Then
        let result = currencyConverter.convertCurrency(amount: amount, selectedCurrency: currency, currencyArray: currencyData)
        
        let expectedEURAmount = String((50000.0).displayCurrency.dropLast(2))
        let expectedUSDAmount = (53837.5398).displayCurrency
        let expectedGBPAmount = (44327.7306).displayCurrency
        let expectedJPYAmount = (7041331.19).displayCurrency
        
        let expectedAmounts = [
            expectedEURAmount,
            expectedUSDAmount,
            expectedGBPAmount,
            expectedJPYAmount
        ]
        let resultAmounts = result.map { $0.amount }
        XCTAssertEqual(resultAmounts, expectedAmounts)
    }
    
    func test_updateAmount_WrongDollarAmount_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.usDollar }).first else { return }
        currency.amount = "not_a_number"
        
        // Then
        let result = currencyConverter.updateAmount(currencyArray: currencyData)
        
        let originalAmounts = currencyData.map { $0.amount }.sorted()
        let resultAmounts = result.map { $0.amount }.sorted()
        
        XCTAssertEqual(resultAmounts, originalAmounts)
    }
    
    func test_updateAmount_DollarAmount_Success() {
        // Given
        let currencies = CurrencyDataFake()
        let currencyData = currencies.currencyData
        
        // When
        guard let currency = currencyData.filter({ $0.code == CurrencyCodes.usDollar }).first else { return }
        currency.amount = (500.00).displayCurrency
        
        // Then
        let result = currencyConverter.updateAmount(currencyArray: currencyData)
        
        let expectedEURAmount = (464.36).displayCurrency
        let expectedUSDAmount = (500.00).displayCurrency
        let expectedGBPAmount = (411.6805).displayCurrency
        let expectedJPYAmount = (65394.251).displayCurrency

        let expectedAmounts = [
            expectedEURAmount,
            expectedUSDAmount,
            expectedGBPAmount,
            expectedJPYAmount
        ]
        let resultAmounts = result.map { $0.amount }
        XCTAssertEqual(resultAmounts, expectedAmounts)
    }
}
