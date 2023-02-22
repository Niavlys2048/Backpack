//
//  TranslateManagerTests.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 15/02/2023.
//

@testable import Backpack
import XCTest

final class TranslateManagerTests: XCTestCase {
    func test_translate_Failed_Error() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(data: nil, response: nil, error: TranslateResponseDataFake.error))
        
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.translate(textToTranslate: textToTranslate, targetLanguage: "en") { success, translateModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translateModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_translate_Failed_WithoutData() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.translate(textToTranslate: textToTranslate, targetLanguage: "en") { success, translateModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translateModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_translate_Failed_InccorectResponse() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(
            data: TranslateResponseDataFake.translateCorrectData,
            response: TranslateResponseDataFake.responseKO, error: nil)
        )
        
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.translate(textToTranslate: textToTranslate, targetLanguage: "en") { success, translateModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translateModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_translate_Failed_InccorectData() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(
            data: TranslateResponseDataFake.translateIncorrectData,
            response: TranslateResponseDataFake.responseOK, error: nil)
        )
        
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.translate(textToTranslate: textToTranslate, targetLanguage: "en") { success, translateModel in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translateModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_translate_Success_CorrectData() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(
            data: TranslateResponseDataFake.translateCorrectData,
            response: TranslateResponseDataFake.responseOK, error: nil)
        )
        
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.translate(textToTranslate: textToTranslate, targetLanguage: "en") { success, translateModel in
            // Then
            let translatedText = "Hello, How old are you?"
            let detectedSourceLanguage = "fr"
            
            XCTAssertTrue(success)
            XCTAssertNotNil(translateModel)
            
            XCTAssertEqual(translatedText, translateModel?.translatedText)
            XCTAssertEqual(detectedSourceLanguage, translateModel?.detectedSourceLanguage)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_fetchSupportedLanguages_Failed_Error() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(data: nil, response: nil, error: LanguageResponseDataFake.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.fetchSupportedLanguages { success, languages in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_fetchSupportedLanguages_Failed_WithoutData() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.fetchSupportedLanguages { success, languages in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_fetchSupportedLanguages_Failed_InccorectResponse() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(
            data: LanguageResponseDataFake.languageCorrectData,
            response: LanguageResponseDataFake.responseKO, error: nil)
        )
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.fetchSupportedLanguages { success, languages in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_fetchSupportedLanguages_Failed_InccorectData() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(
            data: LanguageResponseDataFake.languageIncorrectData,
            response: LanguageResponseDataFake.responseOK, error: nil)
        )
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.fetchSupportedLanguages { success, languages in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func test_fetchSupportedLanguages_Success_CorrectData() {
        // Given
        let translateManager = TranslateManager(session: URLSessionFake(
            data: LanguageResponseDataFake.languageCorrectData,
            response: LanguageResponseDataFake.responseOK, error: nil)
        )
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateManager.fetchSupportedLanguages { success, languages in
            // Then
                        
            let afLanguageName = "Afrikaans"
            let afLanguageCode = "af"

            let akLanguageName = "Akan"
            let akLanguageCode = "ak"
            
            let sqLanguageName = "Albanian"
            let sqLanguageCode = "sq"
            
            let amLanguageName = "Amharic"
            let amLanguageCode = "am"
            
            XCTAssertTrue(success)
            XCTAssertNotNil(languages)
            
            XCTAssertEqual(afLanguageName, languages?[0].name)
            XCTAssertEqual(afLanguageCode, languages?[0].code)
            
            XCTAssertEqual(akLanguageName, languages?[1].name)
            XCTAssertEqual(akLanguageCode, languages?[1].code)
            
            XCTAssertEqual(sqLanguageName, languages?[2].name)
            XCTAssertEqual(sqLanguageCode, languages?[2].code)
            
            XCTAssertEqual(amLanguageName, languages?[3].name)
            XCTAssertEqual(amLanguageCode, languages?[3].code)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
