//
//  GradientView.swift
//  Backpack
//
//  Created by Sylvain Druaux on 09/08/2023.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var secondColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var thirdColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateView()
    }

    func updateView() {
        guard let layer = layer as? CAGradientLayer else { return }
        layer.colors = [firstColor, secondColor, thirdColor].map(\.cgColor)
        if isHorizontal {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
}
