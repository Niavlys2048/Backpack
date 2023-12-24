//
//  AddCurrencyViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 05/02/2023.
//

import UIKit

protocol AddCurrencyViewControllerDelegate: AnyObject {
    func didTapAdd(_ addCurrencyViewController: AddCurrencyViewController)
}

final class AddCurrencyViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var addCurrencyTableView: UITableView!

    // MARK: - Properties

    weak var delegate: AddCurrencyViewControllerDelegate?

    var availableCurrencyData: [Currency] = []
    var currencyData: [Currency] = []
    private var addableCurrencyData: [Currency] = []

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        addCurrencyTableView.dataSource = self
        addCurrencyTableView.delegate = self

        let currentCurrencyCodes = currencyData.map(\.code)
        addableCurrencyData = availableCurrencyData.filter { !currentCurrencyCodes.contains($0.code) }
    }

    // MARK: - Actions

    @IBAction private func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction private func donePressed(_ sender: UIButton) {
        if let selectedRows = addCurrencyTableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                currencyData.append(addableCurrencyData[indexPath.row])
            }
        }
        delegate?.didTapAdd(self)
    }
}

// MARK: - Extensions

// MARK: - addCurrencyTableView DataSource

extension AddCurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addableCurrencyData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addableCurrency = addableCurrencyData[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddCurrencyCell", for: indexPath) as? AddCurrencyTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: addableCurrency)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}

// MARK: - addCurrencyTableView Delegate

extension AddCurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
