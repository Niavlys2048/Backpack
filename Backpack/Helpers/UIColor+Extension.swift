//
//  UIColor+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 19/01/2023.
//

import UIKit

/// Example: UIColor(hex: 0xFFFFFF)
extension UIColor {
    convenience init(hex: Int) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
}
