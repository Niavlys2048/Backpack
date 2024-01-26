//
//  CurrencyCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    @IBOutlet private var flagImageView: UIImageView!
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!

    static let reuseID = "CurrencyCell"

    func configure(with model: Currency) {
        let flag = model.countryCode
        flagImageView.image = UIImage(named: flag)
        currencyLabel.text = model.code
        amountLabel.text = model.amount
        detailLabel.text = "\(model.name), \(model.symbol)"
    }
}
