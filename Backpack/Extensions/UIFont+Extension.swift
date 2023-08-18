//
//  UIFont+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 15/08/2023.
//

import UIKit

public extension UIFont {
    
    var rounded: UIFont {
        guard let desc = self.fontDescriptor.withDesign(.rounded)
        else { return self }
        return UIFont(descriptor: desc, size: self.pointSize)
    }
}
