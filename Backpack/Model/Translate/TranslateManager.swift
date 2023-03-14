//
//  TranslateManager.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import Foundation

final class TranslateManager {
    
    // MARK: - Properties
    static var shared = TranslateManager()
    private var task: URLSessionTask?
    private var session = URLSession(configuration: .default)
    
    lazy var appConfiguration = AppConfiguration()
    private var apiKey: String?
    
    // MARK: - Enum
    enum DataError: Error {
        case failedToConnect, failedToGetData, failedToParseData
    }
    
    // MARK: - Methods
    init(session: URLSession) {
        self.session = session
    }
    
    private init() {
        apiKey = appConfiguration.googleApiKey
    }
    
    private func performRequest(usingGoogleTranslateAPI api: GoogleTranslateAPI, urlParams: [String: String], completion: @escaping (Result<Any?, Error>) -> Void) {
        
        // 1. Retrieve url from GoogleTranslateAPI
        guard var components = URLComponents(string: api.getURL()) else {
            completion(.failure(DataError.failedToConnect))
            return
        }
        
        // 2. Building final url with all parameters
        components.queryItems = [URLQueryItem]()
        for (key, value) in urlParams {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        // 3. Create final url
        guard let url = components.url else {
            completion(.failure(DataError.failedToConnect))
            return
        }
        
        // 4. Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = api.getHTTPMethod()
        
        // 5. Create URLSession (see Dependency injection for unit tests)
        
        // Cancel the previous task if another request happens
        task?.cancel()
        
        // 6. Give the session a task
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let safeData = data, error == nil else {
                    completion(.failure(DataError.failedToConnect))
                    return
                }
                
                guard let safeResponse = response as? HTTPURLResponse, safeResponse.statusCode == 200 else {
                    completion(.failure(DataError.failedToGetData))
                    return
                }
                
                switch api {
                case .translate:
                    guard let translate = self.parseTranslateJSON(safeData) else {
                        completion(.failure(DataError.failedToParseData))
                        return
                    }
                    completion(.success(translate))
                case .supportedLanguages:
                    guard let languages = self.parseLanguagesJSON(safeData) else {
                        completion(.failure(DataError.failedToParseData))
                        return
                    }
                    completion(.success(languages))
                }
            }
        })
        
        // 7. Start the task
        task?.resume()
    }
    
    func translate(
        textToTranslate: String,
        targetLanguage: String,
        completion: @escaping (Result<TranslateModel?, Error>
        ) -> Void) {
        
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["q"] = textToTranslate
        urlParams["target"] = targetLanguage
        
        performRequest(usingGoogleTranslateAPI: .translate, urlParams: urlParams) { result in
            switch result {
            case .success(let data):
                guard let translate = data as? TranslateModel else {
                    return
                }
                completion(.success(translate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSupportedLanguages(completion: @escaping (Result<[LanguageModel]?, Error>) -> Void) {
        
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        performRequest(usingGoogleTranslateAPI: .supportedLanguages, urlParams: urlParams) { result in
            
            switch result {
            case .success(let data):
                guard let languages = data as? [LanguageModel] else {
                    return
                }
                completion(.success(languages))
            case .failure(let error):
                completion(.failure(error))
            }
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
