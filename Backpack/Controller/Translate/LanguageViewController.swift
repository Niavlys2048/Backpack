//
//  LanguageViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import UIKit

// https://jamesrochabrun.medium.com/implementing-delegates-in-swift-step-by-step-d3211cbac3ef
protocol LanguageViewControllerDelegate: AnyObject {
    func didTapLanguage(_ languageViewController: LanguageViewController)
}

final class LanguageViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var translateLabel: UILabel!
    @IBOutlet private var languageSearchBar: UISearchBar!
    @IBOutlet private var languageTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    weak var delegate: LanguageViewControllerDelegate?
    
    // Data for languageTableView
    var supportedLanguageData: [LanguageModel] = []
    var filteredData: [LanguageModel] = []
    var languageData: LanguageModel?
    
    var selectedLanguage: SelectedLanguage = .sourceLanguage
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        
        languageSearchBar.delegate = self
        
        // Init title
        switch selectedLanguage {
        case .sourceLanguage:
            translateLabel.text = "Translate from"
        case .targetLanguage:
            translateLabel.text = "Translate to"
        }
        
        // Init searchBar
        let textFieldInsideSearchBar = languageSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.overrideUserInterfaceStyle = .dark
        if self.traitCollection.userInterfaceStyle == .light {
            textFieldInsideSearchBar?.keyboardAppearance = .light
        }
        
        getSupportedLanguages()
    }
    
    private func getSupportedLanguages() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String,
                !apiKey.isEmpty else {
            presentAlert(.missingApiKey)
            return
        }
        activityIndicator.isHidden = false
        TranslateManager.shared.fetchSupportedLanguages { success, languages in
            self.activityIndicator.isHidden = true
            guard let languages, success else {
                self.presentAlert(.connectionFailed)
                return
            }
            self.supportedLanguageData = languages
            
            // Init supported languages list
            self.supportedLanguageData = self.supportedLanguageData.sorted { $0.name < $1.name }
            
            if self.selectedLanguage == .sourceLanguage {
                self.supportedLanguageData.insert(LanguageModel(name: "Detect language", code: "detect"), at: 0)
            }
            
            self.filteredData = self.supportedLanguageData
            self.languageTableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - Extensions

// MARK: - languageTableView DataSource
extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let supportedLanguage = filteredData[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.languageLabel.text = supportedLanguage.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark

            languageData = filteredData[indexPath.row]
            delegate?.didTapLanguage(self)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}

// MARK: - languageTableView Delegate
extension LanguageViewController: UITableViewDelegate {}

// MARK: - languageSearchBar Delegate to find language faster
extension LanguageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredData = supportedLanguageData
        } else {
            filteredData = supportedLanguageData.filter { data in
                return data.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        languageTableView.reloadData()
    }
}
