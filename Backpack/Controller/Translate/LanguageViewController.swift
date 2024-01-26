//
//  LanguageViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 14/02/2023.
//

import UIKit

protocol LanguageViewControllerDelegate: AnyObject {
    func didTapLanguage(_ languageVC: LanguageViewController)
}

final class LanguageViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var translateLabel: UILabel!
    @IBOutlet private var languageSearchBar: UISearchBar!
    @IBOutlet private var languageTableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    weak var delegate: LanguageViewControllerDelegate?

    private var supportedLanguageData: [LanguageModel] = []
    private var filteredData: [LanguageModel] = []
    var languageData: LanguageModel?

    var selectedLanguage: SelectedLanguage = .sourceLanguage

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getSupportedLanguages()
    }

    // MARK: - Actions

    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    // MARK: - View

    private func configure() {
        languageTableView.dataSource = self
        languageTableView.delegate = self
        languageSearchBar.delegate = self

        switch selectedLanguage {
        case .sourceLanguage:
            translateLabel.text = "Translate from"

        case .targetLanguage:
            translateLabel.text = "Translate to"
        }
    }

    private func getSupportedLanguages() {
        activityIndicator.isHidden = false
        TranslateService.shared.getLanguages { [weak self] result in
            guard let self else { return }
            activityIndicator.isHidden = true

            switch result {
            case .success(let languageResponse):
                let supportedLanguages = LanguagesModel(languageResponse: languageResponse).languages
                supportedLanguageData = supportedLanguages.sorted { $0.name < $1.name }

                if selectedLanguage == .sourceLanguage {
                    supportedLanguageData.insert(LanguageModel(name: "Detect language", code: "detect"), at: 0)
                }

                filteredData = supportedLanguageData
                languageTableView.reloadData()
            case .failure(let error):
                presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
}

// MARK: - languageTableView DataSource

extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let supportedLanguage = filteredData[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.reuseID, for: indexPath) as? LanguageCell else {
            return UITableViewCell()
        }

        cell.configure(with: supportedLanguage)
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
                data.name.lowercased().contains(searchText.lowercased())
            }
        }

        languageTableView.reloadData()
    }
}
