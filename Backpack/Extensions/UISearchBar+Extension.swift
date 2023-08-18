//
//  UISearchBar+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 10/08/2023.
//

import UIKit

extension UISearchBar {
    func setTextFieldColor(hexColor: Int, transparency: CGFloat) {
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(hex: hexColor, alpha: transparency)
        }
    }
}
