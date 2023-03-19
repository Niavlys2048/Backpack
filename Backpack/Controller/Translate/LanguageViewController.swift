//
//  LanguageViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import UIKit

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
        initView()
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        languageSearchBar.delegate = self
        
        getSupportedLanguages()
    }
    
    private func initView() {
        switch selectedLanguage {
        case .sourceLanguage:
            translateLabel.text = "Translate from"
        case .targetLanguage:
            translateLabel.text = "Translate to"
        }
        
        let textFieldInsideSearchBar = languageSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.overrideUserInterfaceStyle = .dark
        if self.traitCollection.userInterfaceStyle == .light { textFieldInsideSearchBar?.keyboardAppearance = .light }
    }
    
    private func getSupportedLanguages() {
        activityIndicator.isHidden = false
        TranslateService.shared.fetchSupportedLanguages { [weak self] result in
            self?.activityIndicator.isHidden = true
            switch result {
            case .success(let languages):
                guard let supportedLanguages = languages else { return }
                self?.supportedLanguageData = supportedLanguages
                
                guard var supportedLanguages = self?.supportedLanguageData else { return }
                self?.supportedLanguageData = supportedLanguages.sorted { $0.name < $1.name }
                
                if self?.selectedLanguage == .sourceLanguage {
                    supportedLanguages.insert(LanguageModel(name: "Detect language", code: "detect"), at: 0)
                }
                
                self?.filteredData = supportedLanguages
                self?.languageTableView.reloadData()
            case .failure(let error):
                self?.presentAlert(.connectionFailed)
                print(error)
            }
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
