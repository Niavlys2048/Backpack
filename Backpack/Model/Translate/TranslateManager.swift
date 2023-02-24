//
//  TranslateManager.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

// https://cloud.google.com/translate/docs/basic/translating-text

import Foundation

final class TranslateManager {
    
    // MARK: - Properties
    // shared represents unique instance of the class
    static var shared = TranslateManager()
    
    private let translateURL = "https://translation.googleapis.com/language/translate/v2/"
    private var task: URLSessionTask?
    
    // Dependency injection (for unit tests)
    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
    
    private var apiKey: String?
    
    // MARK: - Methods
    // Make init private to become inaccessible from outside
    private init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String
        
        guard let apiKey, !apiKey.isEmpty else {
            print("Error: Missing Google API key")
            return
        }
    }
    
    // Generic request for multiple case scenario
    private func performRequest(usingGoogleTranslateAPI api: GoogleTranslateAPI, urlParams: [String: String], callback: @escaping (Bool, Any?) -> Void) {
        
        // 1. Retrieve url from GoogleTranslateAPI
        guard var components = URLComponents(string: api.getURL()) else {
            callback(false, nil)
            return
        }
        
        // 2. Building final url with all parameters
        // https://stackoverflow.com/questions/34060754/how-can-i-build-a-url-with-query-parameters-containing-multiple-values-for-the-s
        components.queryItems = [URLQueryItem]()
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        // 3. Create a URL
        if let url = components.url {
            // 4. Create URLRequest
            var request = URLRequest(url: url)
            request.httpMethod = api.getHTTPMethod()
            
            // 5. Create URLSession (see Dependency injection for unit tests)
            
            // Cancel the previous task if a new request is added before the previous task is completed
            task?.cancel()
            
            // 6. Give the session a task
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    guard let safeData = data, error == nil else {
                        callback(false, nil)
                        return
                    }
                    
                    guard let safeResponse = response as? HTTPURLResponse, safeResponse.statusCode == 200 else {
                        callback(false, nil)
                        return
                    }
                    
                    switch api {
                    case .translate:
                        guard let translate = self.parseTranslateJSON(safeData) else {
                            callback(false, nil)
                            return
                        }
                        callback(true, translate)
                    case .supportedLanguages:
                        guard let languages = self.parseLanguagesJSON(safeData) else {
                            callback(false, nil)
                            return
                        }
                        callback(true, languages)
                    }
                }
            })
        }
        
        // 7. Start the task
        task?.resume()
    }
    
    func translate(textToTranslate: String, targetLanguage: String, callback: @escaping (Bool, TranslateModel?) -> Void) {
        
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["q"] = textToTranslate
        urlParams["target"] = targetLanguage
        
        performRequest(usingGoogleTranslateAPI: .translate, urlParams: urlParams) { success, result in
            
            guard let translateModel = result as? TranslateModel else {
                callback(false, nil)
                return
            }
            callback(success, translateModel)
        }
    }
    
    func fetchSupportedLanguages(callback: @escaping (Bool, [LanguageModel]?) -> Void) {
        
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        performRequest(usingGoogleTranslateAPI: .supportedLanguages, urlParams: urlParams) { success, result in
            
            guard let languages = result as? [LanguageModel] else {
                callback(false, nil)
                return
            }
            callback(success, languages)
        }
    }
    
    private func parseTranslateJSON(_ translateData: Data) -> TranslateModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TranslateData.self, from: translateData)
            
            guard let translation = decodedData.data.translations.first else {
                return nil
            }
            
            let translatedText = translation.translatedText.html2String
            let detectedSourceLanguage = translation.detectedSourceLanguage
            
            let translate = TranslateModel(translatedText: translatedText, detectedSourceLanguage: detectedSourceLanguage)
            return translate
        } catch {
            return nil
        }
    }
    
    private func parseLanguagesJSON(_ languageData: Data) -> [LanguageModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LanguageData.self, from: languageData)
            
            var languages = [LanguageModel]()
            
            let languagesData = decodedData.data.languages
            for languageData in languagesData {
                let language = LanguageModel(name: languageData.name, code: languageData.language)
                languages.append(language)
            }
            
            return languages
        } catch {
            return nil
        }
    }
}
