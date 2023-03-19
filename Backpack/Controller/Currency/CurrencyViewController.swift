//
//  CurrencyViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 30/01/2023.
//

import UIKit

final class CurrencyViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private var currencyTableView: UITableView!
    @IBOutlet private var inputTextField: UITextField!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
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
    
    // Used to keep currencyTableView selected cell visible on top of the keyboard
    private var currencyTableViewContentOffset: CGPoint = .zero
    private var currencyTableViewContentInset = UIEdgeInsets()
    private var typingAmount: Bool = false
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()
        initAvailableCurrencyData()
        updateRates()
        initCurrencyData()
        
        currencyTableView.refreshControl = UIRefreshControl()
        currencyTableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        
        currencyTableView.dataSource = self
        currencyTableView.delegate = self
        
        inputTextField.delegate = self
        
        let numberFormatter = NumberFormatter()
        decimalSeparator = numberFormatter.locale.decimalSeparator ?? "."
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    private func initAvailableCurrencyData() {
        let localeIDs = Locale.availableIdentifiers
        
        for localeID in localeIDs {
            let locale = Locale(identifier: localeID)
            let currencyCode = locale.currencyCode
            if let currencyCode, mainCurrencyCodes.contains(currencyCode), !availableCurrencyData.contains(where: {
                $0.code == currencyCode }
            ) {
                let currency = Currency(countryId: localeID)
                availableCurrencyData.append(currency)
            }
        }
    }
    
    private func initCurrencyData() {
        let startingCurrencyList = CurrencyCodes.defaultCurrencies
        currencyData = availableCurrencyData.filter { currency in
            return startingCurrencyList.contains(currency.code)
        }
    }
    
    private func updateRates() {
        activityIndicator.isHidden = false
        RateService.shared.performRequest { [weak self] result in
            self?.activityIndicator.isHidden = true
            switch result {
            case .success(let rates):
                self?.rates = rates
                
                guard let availableCurrencies = self?.availableCurrencyData else { return }
                for currency in availableCurrencies {
                    for rate in rates where currency.code == rate.currencyCode {
                        currency.rate = rate.currencyRate
                    }
                }
            case .failure(let error):
                self?.presentAlert(.connectionFailed)
                print(error)
            }
        }
        
        guard !currencyData.isEmpty else { return }
        for currency in self.currencyData {
            for rate in rates where currency.code == rate.currencyCode {
                currency.rate = rate.currencyRate
            }
        }
    }
    
    private func updateCurrencyData() {
        let newCurrencyArray = self.currencyConverter.updateAmount(currencyArray: self.currencyData)
        self.currencyData = newCurrencyArray
        
        self.currencyTableView.refreshControl?.endRefreshing()
        self.currencyTableView.reloadData()
    }
    
    private func initNavigationBar() {
        title = "Currency"
        menuButton = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis.circle"),
            primaryAction: nil,
            menu: generatePullDownMenu()
        )
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func generatePullDownMenu() -> UIMenu {
        let addItem = UIAction(
            title: "Add Currency",
            image: UIImage(systemName: "plus"),
            handler: { _ in
                self.addCurrency()
            }
        )
        
        let editItem = UIAction(
            title: "Edit List",
            image: UIImage(systemName: "pencil"),
            handler: { _ in
                self.editList()
            }
        )
        
        menu = UIMenu(options: .displayInline, children: [addItem, editItem])
        return menu
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addCurrencyVC = segue.destination as? AddCurrencyViewController {
            addCurrencyVC.delegate = self
            addCurrencyVC.availableCurrencyData = availableCurrencyData
            addCurrencyVC.currencyData = currencyData
        }
    }
    
    private func addCurrency() {
        self.performSegue(withIdentifier: "segueToAddCurrency", sender: self)
    }
    
    private func editList() {
        menuButton.title = "Done"
        menuButton.image = nil
        menuButton.menu = nil
        menuButton.action = #selector(exitEditing)
        menuButton.target = self
        
        currencyTableView.isEditing.toggle()
    }
    
    // MARK: - Actions
    @objc private func callPullToRefresh() {
        // Rates update disabled to avoid too much API calls
//        updateRates()
        updateCurrencyData()
    }
    
    @objc private func exitEditing() {
        menuButton.title = nil
        menuButton.image = UIImage(systemName: "ellipsis.circle")
        menuButton.menu = generatePullDownMenu()
        menuButton.action = nil
        
        if currencyTableView.isEditing { currencyTableView.isEditing = false }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        guard let selectedIndexPath = currencyTableView.indexPathForSelectedRow, !typingAmount else { return }
        
        let selectedCellRect = currencyTableView.rectForRow(at: selectedIndexPath)
        let tableViewBottom = currencyTableView.frame.size.height + currencyTableView.contentOffset.y
        let cellBottom = selectedCellRect.origin.y + selectedCellRect.size.height
        let difference = tableViewBottom - cellBottom
        
        guard difference < keyboardSize.height else { return }
        
        currencyTableViewContentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        currencyTableView.contentInset = currencyTableViewContentInset
        currencyTableView.scrollIndicatorInsets = currencyTableViewContentInset
        
        let contentOffset = currencyTableView.contentOffset
        let newPosition = contentOffset.y + keyboardSize.height - difference
        
        currencyTableViewContentOffset = CGPoint(x: contentOffset.x, y: newPosition)
        currencyTableView.contentOffset = currencyTableViewContentOffset
        
        typingAmount = true
    }
      
    @objc private func keyboardWillHide(notification: NSNotification) {
        currencyTableView.contentInset = .zero
        currencyTableView.scrollIndicatorInsets = .zero
        currencyTableView.contentOffset = .zero
        currencyTableViewContentOffset = .zero
        currencyTableViewContentInset = UIEdgeInsets()
        typingAmount = false
    }
}

// MARK: - Extensions

// MARK: - AddCurrencyViewControllerDelegate to display the city and add it to CurrencyTableView
extension CurrencyViewController: AddCurrencyViewControllerDelegate {
    func didTapAdd(_ addCurrencyViewController: AddCurrencyViewController) {
        currencyData = addCurrencyViewController.currencyData
        updateCurrencyData()
        
        addCurrencyViewController.dismiss(animated: true)
    }
}

// MARK: - currencyTableView DataSource
extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = currencyData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }
        
        let flag = currency.countryCode
        cell.flagImageView.image = UIImage(named: flag)
        cell.currencyLabel.text = currency.code
        cell.amountLabel.text = currency.amount
        
        cell.detailLabel.text = "\(currency.name), \(currency.symbol)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
        inputTextField.text = ""
        inputTextField.becomeFirstResponder()
    }
}

// MARK: - currencyTableView Delegate
extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - inputTextField Delegate
extension CurrencyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let selectedIndexPath = currencyTableView.indexPathForSelectedRow else { return false }
        let selectedCurrency = currencyData[selectedIndexPath.row]
        
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let currentTextHasDecimalSeparator = currentText.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)

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
        
        let newCurrencyArray = currencyConverter.convertCurrency(
            amount: replacementText,
            selectedCurrency: selectedCurrency,
            currencyArray: currencyData
        )
        currencyData = newCurrencyArray
        currencyTableView.reloadData()
        
        currencyTableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        
        currencyTableView.contentInset = currencyTableViewContentInset
        currencyTableView.scrollIndicatorInsets = currencyTableViewContentInset
        currencyTableView.contentOffset = currencyTableViewContentOffset
        
        return true
    }
}
