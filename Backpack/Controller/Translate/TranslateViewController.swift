//
//  TranslateViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 30/01/2023.
//

import UIKit

// MARK: - Enum (Global)
enum SelectedLanguage {
    case sourceLanguage, targetLanguage
}

final class TranslateViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private var sourceLanguageButton: UIButton!
    @IBOutlet private var targetLanguageButton: UIButton!
    
    @IBOutlet private var sourceLanguageLabel: UILabel!
    @IBOutlet private var sourceTextView: UITextView!
    @IBOutlet private var clearButton: UIButton!
    
    @IBOutlet private var targetLanguageLabel: UILabel!
    @IBOutlet private var targetTextView: UITextView!
    @IBOutlet private var validationButton: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var translation: TranslateModel?
    private var selectedLanguage: SelectedLanguage = .sourceLanguage
    private var supportedLanguageData: [LanguageModel] = []
    
    private var sourceLanguage: String = "detect"
    private var targetLanguage: String = "en"
    
    private let locale = Locale.current
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Navigation Bar
        title = "Google Translate"
        
        // Init View
        sourceTextView.text = "Enter text"
        sourceTextView.textColor = UIColor.lightGray
        targetTextView.text = nil
        
        sourceTextView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let changeLanguageVC = segue.destination as? LanguageViewController {
            changeLanguageVC.delegate = self
            changeLanguageVC.selectedLanguage = selectedLanguage
            
            // Get the current source/target language
            let button = sender as? UIButton
            
            guard let languageName = button?.currentTitle else {
                return
            }
            
            guard var languageCode = locale.localizedString(forLanguageCode: languageName) else {
                return
            }
            
            if languageName.contains("Detect") {
                languageCode = "detect"
            }
            changeLanguageVC.languageData = LanguageModel(name: languageName, code: languageCode)
        }
    }
    
    private func translateText() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String,
                !apiKey.isEmpty else {
            presentAlert(.missingApiKey)
            return
        }
        
        activityIndicator.isHidden = false
        // https://www.avanderlee.com/swift/weak-self/
        TranslateManager.shared.translate(textToTranslate: sourceTextView.text, targetLanguage: targetLanguage) { [weak self] success, translation in
            self?.activityIndicator.isHidden = true
            guard let translation, success else {
                self?.presentAlert(.connectionFailed)
                return
            }
            self?.targetTextView.text = translation.translatedText
            
            // Set sourceLanguageLabel text
            guard let selectedSourceLanguage = self?.sourceLanguage else {
                return
            }
            var sourceLanguageName = self?.locale.localizedString(forIdentifier: selectedSourceLanguage)
            let detectedSourceLanguage = translation.detectedSourceLanguage
            if selectedSourceLanguage.contains("detect") || selectedSourceLanguage != detectedSourceLanguage {
                sourceLanguageName = self?.locale.localizedString(forIdentifier: detectedSourceLanguage)
                self?.sourceLanguageButton.setTitle("Detect language", for: .normal)
            }
            self?.sourceLanguageLabel.text = sourceLanguageName?.uppercased()
            
            // Set targetLanguageLabel text
            guard let targetLanguage = self?.targetLanguage else {
                return
            }
            let targetLanguageName = self?.locale.localizedString(forIdentifier: targetLanguage)
            self?.targetLanguageLabel.text = targetLanguageName?.uppercased()
        }
    }
    
    // MARK: - Actions
    @IBAction private func sourceLanguageButtonPressed(_ sender: UIButton) {
        // Send the current sourceLanguage to segue to ask whether or not we change the language
        selectedLanguage = .sourceLanguage
        self.performSegue(withIdentifier: "segueToChangeLanguage", sender: sender)
    }
    
    @IBAction private func targetLanguageButtonPressed(_ sender: UIButton) {
        // Send the current targetLanguage to segue to ask whether or not we change the language
        selectedLanguage = .targetLanguage
        self.performSegue(withIdentifier: "segueToChangeLanguage", sender: sender)
    }
    
    @IBAction private func clearButtonPressed(_ sender: UIButton) {
        sourceTextView.resignFirstResponder()
        sourceTextView.text = "Enter text"
        sourceTextView.textColor = UIColor.lightGray
        targetTextView.text = nil
        clearButton.isHidden = true
        validationButton.isHidden = true
        sourceLanguageLabel.isHidden = true
        targetLanguageLabel.isHidden = true
    }
    
    @IBAction private func validationButtonPressed(_ sender: UIButton) {
        guard !sourceTextView.text.isEmpty else {
            return
        }
        
        sourceTextView.resignFirstResponder()
        sourceLanguageLabel.isHidden = false
        targetLanguageLabel.isHidden = false
        validationButton.isHidden = true
        
        // translate
        translateText()
    }
}

// MARK: - Extensions

// MARK: - LanguageViewControllerDelegate to update source/target language
extension TranslateViewController: LanguageViewControllerDelegate {
    func didTapLanguage(_ languageViewController: LanguageViewController) {
        // Update selected language
        guard let language = languageViewController.languageData else {
            return
        }
        
        let languageCode = language.code
        let languageName = language.name
        
        switch selectedLanguage {
        case .sourceLanguage:
            let previousSourceLanguage = sourceLanguage
            sourceLanguage = languageCode
            sourceLanguageLabel.text = languageName
            sourceLanguageButton.setTitle(languageName, for: .normal)
            if sourceLanguage != previousSourceLanguage, !sourceTextView.text.isEmpty, sourceTextView.textColor != .lightGray {
                translateText()
            }
        case .targetLanguage:
            let previousTargetLanguage = targetLanguage
            targetLanguage = languageCode
            targetLanguageLabel.text = languageName
            targetLanguageButton.setTitle(languageName, for: .normal)
            if targetLanguage != previousTargetLanguage, !targetTextView.text.isEmpty {
                translateText()
            }
        }
        languageViewController.dismiss(animated: true)
    }
}

// MARK: - TextViewDelegate to update source/target TextViews
extension TranslateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // https://stackoverflow.com/questions/27652227/add-placeholder-text-inside-uitextview-in-swift
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkGray
            clearButton.isHidden = false
            validationButton.alpha = 0.6
            validationButton.isHidden = false
        } else {
            sourceLanguageLabel.isHidden = true
            targetLanguageLabel.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validationButton.alpha = 1
        sourceTextView.textColor = UIColor(named: "defaultColor")
        // Real-time translation (disabled to avoid too much API calls)
//        translateText()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            guard !textView.text.isEmpty else {
                return false
            }
            textView.resignFirstResponder()
            sourceLanguageLabel.isHidden = false
            targetLanguageLabel.isHidden = false
            validationButton.isHidden = true
            
            // translate
            translateText()
            
            return false
        }
        return true
    }
}
