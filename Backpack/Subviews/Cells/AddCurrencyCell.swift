//
//  AddCurrencyCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 05/02/2023.
//

import UIKit

final class AddCurrencyCell: UITableViewCell {
    @IBOutlet private var flagImageView: UIImageView!
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!

    static let reuseID = "AddCurrencyCell"

    func configure(with model: Currency) {
        let flag = model.countryCode
        flagImageView.image = UIImage(named: flag)
        currencyLabel.text = model.code
        detailLabel.text = "\(model.name), \(model.symbol)"
    }
}
