//
//  LanguageTableViewCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 15/02/2023.
//

import UIKit

final class LanguageTableViewCell: UITableViewCell {
    @IBOutlet var languageLabel: UILabel!

    func configure(with model: LanguageModel) {
        languageLabel.text = model.name
    }
}
