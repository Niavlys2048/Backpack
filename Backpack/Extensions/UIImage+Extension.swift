//
//  UIImage+Extension.swift
//  Backpack
//
//  Created by Sylvain Druaux on 06/02/2023.
//

import UIKit

extension UIImage {
    func addBackgroundRounded(size: CGSize, color: UIColor?, cornerRadius: CGFloat) -> UIImage? {
        let roundedBoxSize = size
        let roundedBoxFrame = CGRect(x: 0, y: 0, width: roundedBoxSize.width, height: roundedBoxSize.height)
        let imageSize = CGSize(width: size.width / 2, height: size.height / 2)
        let imageFrame = CGRect(
            x: (roundedBoxFrame.width - imageSize.width) * 0.5,
            y: (roundedBoxFrame.height - imageSize.height) * 0.5,
            width: imageSize.width,
            height: imageSize.height
        )

        let view = UIView(frame: roundedBoxFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = cornerRadius

        UIGraphicsBeginImageContextWithOptions(roundedBoxSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: roundedBoxSize)
        let roundedBoxImage = renderer.image { _ in
            view.drawHierarchy(in: roundedBoxFrame, afterScreenUpdates: true)
        }

        roundedBoxImage.draw(in: roundedBoxFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
