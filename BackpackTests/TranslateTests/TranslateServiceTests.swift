//
//  TranslateServiceTests.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 15/02/2023.
//

@testable import Backpack
import XCTest

final class TranslateServiceTests: XCTestCase {
    func test_translate_Failed_Error() {
        // Given
        let restApiClient = RestAPIClient(session: URLSessionFake(data: nil, response: nil, error: TranslateResponseDataFake.error))
        let translateService = TranslateService(restAPIClient: restApiClient)
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getTranslation(textToTranslate: textToTranslate, targetLanguage: "en") { result in
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

    func test_translate_Failed_WithoutData() {
        // Given
        let restApiClient = RestAPIClient(session: URLSessionFake(data: nil, response: nil, error: nil))
        let translateService = TranslateService(restAPIClient: restApiClient)
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getTranslation(textToTranslate: textToTranslate, targetLanguage: "en") { result in
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

    func test_translate_Failed_IncorrectResponse() {
        // Given
        let restApiClient = RestAPIClient(
            session: URLSessionFake(
                data: TranslateResponseDataFake.translateCorrectData,
                response: TranslateResponseDataFake.responseKO, error: nil
            )
        )
        let translateService = TranslateService(restAPIClient: restApiClient)
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getTranslation(textToTranslate: textToTranslate, targetLanguage: "en") { result in
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

    func test_translate_Failed_IncorrectData() {
        // Given
        let restApiClient = RestAPIClient(
            session: URLSessionFake(
                data: TranslateResponseDataFake.translateIncorrectData,
                response: TranslateResponseDataFake.responseOK, error: nil
            )
        )
        let translateService = TranslateService(restAPIClient: restApiClient)
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getTranslation(textToTranslate: textToTranslate, targetLanguage: "en") { result in
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

    func test_translate_Success_CorrectData() {
        // Given
        let restApiClient = RestAPIClient(
            session: URLSessionFake(
                data: TranslateResponseDataFake.translateCorrectData,
                response: TranslateResponseDataFake.responseOK, error: nil
            )
        )
        let translateService = TranslateService(restAPIClient: restApiClient)
        let textToTranslate = "Bonjour, Quel âge avez-vous ?"

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getTranslation(textToTranslate: textToTranslate, targetLanguage: "en") { result in
            // Then
            let translatedText = "Hello, How old are you?"
            let detectedSourceLanguage = "fr"
            switch result {
            case .success(let translateResponse):
                let translation = TranslateModel(translateResponse: translateResponse)
                XCTAssertEqual(translatedText, translation.translatedText)
                XCTAssertEqual(detectedSourceLanguage, translation.detectedSourceLanguage)
            case .failure:
                XCTFail(#function)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func test_fetchSupportedLanguages_Failed_Error() {
        // Given
        let restApiClient = RestAPIClient(session: URLSessionFake(data: nil, response: nil, error: LanguageResponseDataFake.error))
        let translateService = TranslateService(restAPIClient: restApiClient)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getLanguages { result in
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

    func test_fetchSupportedLanguages_Failed_WithoutData() {
        // Given
        let restApiClient = RestAPIClient(session: URLSessionFake(data: nil, response: nil, error: nil))
        let translateService = TranslateService(restAPIClient: restApiClient)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getLanguages { result in
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

    func test_fetchSupportedLanguages_Failed_IncorrectResponse() {
        // Given
        let restApiClient = RestAPIClient(
            session: URLSessionFake(
                data: LanguageResponseDataFake.languageCorrectData,
                response: LanguageResponseDataFake.responseKO, error: nil
            )
        )
        let translateService = TranslateService(restAPIClient: restApiClient)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getLanguages { result in
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

    func test_fetchSupportedLanguages_Failed_IncorrectData() {
        // Given
        let restApiClient = RestAPIClient(
            session: URLSessionFake(
                data: LanguageResponseDataFake.languageIncorrectData,
                response: LanguageResponseDataFake.responseOK, error: nil
            )
        )
        let translateService = TranslateService(restAPIClient: restApiClient)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getLanguages { result in
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

    func test_fetchSupportedLanguages_Success_CorrectData() {
        // Given
        let restApiClient = RestAPIClient(
            session: URLSessionFake(
                data: LanguageResponseDataFake.languageCorrectData,
                response: LanguageResponseDataFake.responseOK, error: nil
            )
        )
        let translateService = TranslateService(restAPIClient: restApiClient)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.getLanguages { result in
            // Then
            let afLanguageName = "Afrikaans"
            let afLanguageCode = "af"

            let akLanguageName = "Akan"
            let akLanguageCode = "ak"

            let sqLanguageName = "Albanian"
            let sqLanguageCode = "sq"

            let amLanguageName = "Amharic"
            let amLanguageCode = "am"

            switch result {
            case .success(let languageResponse):
                let languages = LanguagesModel(languageResponse: languageResponse).languages
                XCTAssertEqual(afLanguageName, languages[0].name)
                XCTAssertEqual(afLanguageCode, languages[0].code)

                XCTAssertEqual(akLanguageName, languages[1].name)
                XCTAssertEqual(akLanguageCode, languages[1].code)

                XCTAssertEqual(sqLanguageName, languages[2].name)
                XCTAssertEqual(sqLanguageCode, languages[2].code)

                XCTAssertEqual(amLanguageName, languages[3].name)
                XCTAssertEqual(amLanguageCode, languages[3].code)
            case .failure:
                XCTFail(#function)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
