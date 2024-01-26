//
//  LanguageCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 15/02/2023.
//

import UIKit

final class LanguageCell: UITableViewCell {
    @IBOutlet private var languageLabel: UILabel!

    static let reuseID = "LanguageCell"

    func configure(with model: LanguageModel) {
        languageLabel.text = model.name
    }
}
