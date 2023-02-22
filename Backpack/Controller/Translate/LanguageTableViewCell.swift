//
//  LanguageTableViewCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 15/02/2023.
//

import UIKit

final class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet var languageLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
