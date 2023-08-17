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
    @IBOutlet private var arrowButton: UIButton!
    
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
        
        initView()
        sourceTextView.delegate = self
    }
    
    private func initView() {
        title = "Google Translate"
        sourceTextView.text = "Enter text"
        sourceTextView.textColor = UIColor.lightGray
        targetTextView.text = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let changeLanguageVC = segue.destination as? LanguageViewController {
            changeLanguageVC.delegate = self
            changeLanguageVC.selectedLanguage = selectedLanguage
            
            let button = sender as? UIButton
            guard let languageName = button?.currentTitle else { return }
            guard var languageCode = locale.localizedString(forLanguageCode: languageName) else { return }
            languageCode = languageName.contains("Detect") ? "detect" : languageCode
            
            changeLanguageVC.languageData = LanguageModel(name: languageName, code: languageCode)
        }
    }
    
    private func translateText() {
        activityIndicator.isHidden = false
        TranslateService.shared.getTranslation(textToTranslate: sourceTextView.text, targetLanguage: targetLanguage) { [weak self] result in
            self?.activityIndicator.isHidden = true
            switch result {
            case .success(let translateResponse):
                let translation = TranslateModel(translateResponse: translateResponse)
                self?.targetTextView.text = translation.translatedText
                let detectedSourceLanguage = translation.detectedSourceLanguage
                self?.sourceLanguage = detectedSourceLanguage
                
                guard let sourceLanguageName = self?.locale.localizedString(forIdentifier: detectedSourceLanguage) else { return }
                self?.sourceLanguageButton.setTitle(sourceLanguageName, for: .normal)
                self?.arrowButton.setImage(UIImage(named: "double-arrow"), for: .normal)
                self?.arrowButton.isUserInteractionEnabled = true
                
                self?.sourceLanguageLabel.text = sourceLanguageName
                guard let targetLanguage = self?.targetLanguage else { return }
                let targetLanguageName = self?.locale.localizedString(forIdentifier: targetLanguage)
                self?.targetLanguageLabel.text = targetLanguageName
            case .failure(let error):
                self?.presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction private func sourceLanguageButtonPressed(_ sender: UIButton) {
        selectedLanguage = .sourceLanguage
        self.performSegue(withIdentifier: "segueToChangeLanguage", sender: sender)
    }
    
    @IBAction private func targetLanguageButtonPressed(_ sender: UIButton) {
        selectedLanguage = .targetLanguage
        self.performSegue(withIdentifier: "segueToChangeLanguage", sender: sender)
    }
    
    @IBAction func arrowButtonPressed(_ sender: UIButton) {
        let sourceLanguage = self.sourceLanguage
        let targetLanguage = self.targetLanguage
        let sourceLanguageButtonTitle = sourceLanguageButton.titleLabel?.text
        let targetLanguageButtonTitle = targetLanguageButton.titleLabel?.text
        let sourceLanguageLabelText = sourceLanguageLabel.text
        let targetLanguageLabelText = targetLanguageLabel.text
        
        self.sourceLanguage = targetLanguage
        self.targetLanguage = sourceLanguage
        
        self.sourceLanguageButton.setTitle(targetLanguageButtonTitle, for: .normal)
        self.targetLanguageButton.setTitle(sourceLanguageButtonTitle, for: .normal)
        self.sourceLanguageLabel.text = targetLanguageLabelText
        self.targetLanguageLabel.text = sourceLanguageLabelText
        
        let sourceText = self.sourceTextView.text
        if sourceText != "Enter text" {
            let targetText = self.targetTextView.text
            self.sourceTextView.text = targetText
            self.targetTextView.text = sourceText
        }
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
        guard !sourceTextView.text.isEmpty else { return }
        
        sourceTextView.resignFirstResponder()
        sourceLanguageLabel.isHidden = false
        targetLanguageLabel.isHidden = false
        validationButton.isHidden = true
        
        translateText()
    }
}

// MARK: - Extensions

// MARK: - LanguageViewControllerDelegate to update source/target language
extension TranslateViewController: LanguageViewControllerDelegate {
    func didTapLanguage(_ languageViewController: LanguageViewController) {
        guard let language = languageViewController.languageData else { return }
        
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
            if sourceLanguage == "detect" {
                arrowButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                arrowButton.isUserInteractionEnabled = false
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
        // Real-time translation (delay required to avoid too much api calls)
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
            
            translateText()
            
            return false
        }
        return true
    }
}
