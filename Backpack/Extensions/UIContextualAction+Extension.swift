//
//  UIContextualAction+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 28/08/2023.
//

import UIKit

extension UIContextualAction {
    func configure() {
        image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )?
            .withTintColor(.white, renderingMode: .alwaysTemplate)
            .addBackgroundRounded(
                size: CGSize(width: 60, height: 60),
                color: UIColor(hex: 0xea5545),
                cornerRadius: 10
            )
        backgroundColor = UIColor(white: 1, alpha: 0)
    }
}
