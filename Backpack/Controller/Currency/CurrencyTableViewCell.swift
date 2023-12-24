//
//  CurrencyTableViewCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 03/02/2023.
//

import UIKit

final class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!

    func configure(with model: Currency) {
        let flag = model.countryCode
        flagImageView.image = UIImage(named: flag)
        currencyLabel.text = model.code
        amountLabel.text = model.amount
        detailLabel.text = "\(model.name), \(model.symbol)"
    }
}
