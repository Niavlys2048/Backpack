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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
