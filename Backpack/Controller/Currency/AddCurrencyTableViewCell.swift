//
//  AddCurrencyTableViewCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 05/02/2023.
//

import UIKit

final class AddCurrencyTableViewCell: UITableViewCell {

    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!

    func configure(with model: Currency) {
        let flag = model.countryCode
        flagImageView.image = UIImage(named: flag)
        currencyLabel.text = model.code
        detailLabel.text = "\(model.name), \(model.symbol)"
    }
}
