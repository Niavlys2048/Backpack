//
//  CurrencyViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 30/01/2023.
//

import UIKit

final class CurrencyViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var menuButton: UIBarButtonItem!
    private var menu: UIMenu!

    private let mainCurrencyCodes = CurrencyCodes.mainCurrencies
    private var availableCurrencyData: [Currency] = []
    private var currencyData: [Currency] = []
    private var rates: [RateModel] = []

    private let currencyConverter = CurrencyConverter()
    private lazy var decimalSeparator: String = "."

    // Used to keep the indexPath of the selecected row right before textField become first responder
    private var indexPathForSelectedRow: IndexPath?

    // Used to keep tableView selected cell visible on top of the keyboard
    private var tableViewContentOffset: CGPoint = .zero
    private var tableViewContentInset = UIEdgeInsets()
    private var typingAmount: Bool = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setAvailableCurrencyData()
        updateRates()
        setCurrencyData()
        configureTableView()
        setDecimalSeparator()
        addKeyboardObservers()
        textField.delegate = self
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addCurrencyVC = segue.destination as? AddCurrencyViewController {
            addCurrencyVC.delegate = self
            addCurrencyVC.availableCurrencyData = availableCurrencyData
            addCurrencyVC.currencyData = currencyData
        }
    }

    // MARK: - Actions

    @objc private func callPullToRefresh() {
        // Rates update disabled to avoid too much API calls
//        updateRates()
        updateCurrencyData()
    }

    @objc private func exitEditing() {
        menuButton.title = nil
        menuButton.image = SFSymbols.ellipsis
        menuButton.menu = generatePullDownMenu()
        menuButton.action = nil

        if tableView.isEditing { tableView.isEditing = false }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, !typingAmount else { return }

        let selectedCellRect = tableView.rectForRow(at: selectedIndexPath)
        let tableViewBottom = tableView.frame.size.height + tableView.contentOffset.y
        let cellBottom = selectedCellRect.origin.y + selectedCellRect.size.height
        let difference = tableViewBottom - cellBottom

        guard difference < keyboardSize.height else { return }

        tableViewContentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        tableView.contentInset = tableViewContentInset
        tableView.scrollIndicatorInsets = tableViewContentInset

        let contentOffset = tableView.contentOffset
        let newPosition = contentOffset.y + keyboardSize.height - difference

        tableViewContentOffset = CGPoint(x: contentOffset.x, y: newPosition)
        tableView.contentOffset = tableViewContentOffset

        typingAmount = true
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
        tableView.contentOffset = .zero
        tableViewContentOffset = .zero
        tableViewContentInset = UIEdgeInsets()
        typingAmount = false
    }

    private func addCurrency() {
        performSegue(withIdentifier: "segueToAddCurrency", sender: self)
    }

    private func editList() {
        menuButton.title = "Done"
        menuButton.image = nil
        menuButton.menu = nil
        menuButton.action = #selector(exitEditing)
        menuButton.target = self

        tableView.isEditing.toggle()
    }
}

// MARK: - View

extension CurrencyViewController {
    private func configureNavigationBar() {
        title = "Currency"
        initMenuButton()
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(.text)
    }

    private func setAvailableCurrencyData() {
        let localeIDs = Locale.availableIdentifiers

        for localeID in localeIDs {
            let locale = Locale(identifier: localeID)
            let currencyCode = locale.currencyCode
            if let currencyCode, mainCurrencyCodes.contains(currencyCode),
               !availableCurrencyData.contains(where: { $0.code == currencyCode }) {
                let currency = Currency(countryId: localeID)
                availableCurrencyData.append(currency)
            }
        }
    }

    private func updateRates() {
        activityIndicator.isHidden = false
        RateService.shared.getRates { [weak self] result in
            guard let self else { return }
            activityIndicator.isHidden = true

            switch result {
            case .success(let rateResponse):
                let rates = RatesModel(rateResponse: rateResponse).rates
                self.rates = rates

                let availableCurrencies = availableCurrencyData
                for currency in availableCurrencies {
                    for rate in rates where currency.code == rate.currencyCode {
                        currency.rate = rate.currencyRate
                    }
                }
            case .failure(let error):
                presentAlert(.connectionFailed)
                print(error)
            }
        }

        guard !currencyData.isEmpty else { return }
        for currency in currencyData {
            for rate in rates where currency.code == rate.currencyCode {
                currency.rate = rate.currencyRate
            }
        }
    }

    private func setCurrencyData() {
        let startingCurrencyList = CurrencyCodes.defaultCurrencies
        currencyData = availableCurrencyData.filter { currency in
            startingCurrencyList.contains(currency.code)
        }
    }

    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setDecimalSeparator() {
        let numberFormatter = NumberFormatter()
        decimalSeparator = numberFormatter.locale.decimalSeparator ?? "."
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    private func updateCurrencyData() {
        let newCurrencyArray = currencyConverter.updateAmount(currencyArray: currencyData)
        currencyData = newCurrencyArray

        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    private func initMenuButton() {
        menuButton = UIBarButtonItem(image: SFSymbols.ellipsis, menu: generatePullDownMenu())
    }

    private func generatePullDownMenu() -> UIMenu {
        let addItem = UIAction(title: "Add Currency", image: SFSymbols.plus) { _ in
            self.addCurrency()
        }

        let editItem = UIAction(title: "Edit List", image: SFSymbols.pencil) { _ in
            self.editList()
        }

        menu = UIMenu(options: .displayInline, children: [addItem, editItem])
        return menu
    }
}

// MARK: - AddCurrencyViewControllerDelegate to display the city and add it to TableView

extension CurrencyViewController: AddCurrencyViewControllerDelegate {
    func didTapAdd(_ addCurrencyVC: AddCurrencyViewController) {
        currencyData = addCurrencyVC.currencyData
        updateCurrencyData()

        addCurrencyVC.dismiss(animated: true)
    }
}

// MARK: - tableView DataSource

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = currencyData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseID, for: indexPath) as? CurrencyCell else {
            return UITableViewCell()
        }

        cell.configure(with: currency)
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        currencyData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let currency = currencyData[indexPath.row]
        if currency.code == CurrencyCodes.usDollar || currency.code == CurrencyCodes.euro { return .none }
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            currencyData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.text = ""
        textField.becomeFirstResponder()
    }
}

// MARK: - tableView Delegate

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

// MARK: - textField Delegate

extension CurrencyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return false }
        let selectedCurrency = currencyData[selectedIndexPath.row]

        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)

        guard isValidReplacementText(currentText, replacementText, string) else { return false }

        updateCurrencyData(with: replacementText, selectedCurrency: selectedCurrency, selectedIndexPath: selectedIndexPath)

        return true
    }

    private func isValidReplacementText(_ currentText: String, _ replacementText: String, _ replacementString: String) -> Bool {
        let currentTextHasDecimalSeparator = currentText.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = replacementString.range(of: decimalSeparator)

        if currentTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil { return false }

        let decimalComponents = replacementText.components(separatedBy: decimalSeparator)
        let decimalDigitLimit = decimalComponents.count > 1 ? 2 : 0

        if decimalComponents.count > 2 { return false }

        if decimalComponents.count > 1 {
            let integerPart = decimalComponents.first
            let decimalPart = decimalComponents.last
            guard let integerCount = integerPart?.count else { return false }
            guard let decimalCount = decimalPart?.count else { return false }
            if integerCount > 10 || decimalCount > decimalDigitLimit { return false }
        } else if let integerPart = decimalComponents.first, integerPart.count > 12 { return false }

        return true
    }

    private func updateCurrencyData(with replacementText: String, selectedCurrency: Currency, selectedIndexPath: IndexPath) {
        let newCurrencyArray = currencyConverter.convertCurrency(
            amount: replacementText,
            selectedCurrency: selectedCurrency,
            currencyArray: currencyData
        )
        currencyData = newCurrencyArray
        tableView.reloadData()

        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)

        tableView.contentInset = tableViewContentInset
        tableView.scrollIndicatorInsets = tableViewContentInset
        tableView.contentOffset = tableViewContentOffset
    }
}
