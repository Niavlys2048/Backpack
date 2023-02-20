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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
