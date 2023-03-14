//
//  CustomTabBarController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 25/01/2023.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - First Item
        guard let firstItem = tabBar.items?[0] else { return }
        
        guard let btnImageCurrencyDeselected: UIImage = UIImage(named: "currencyDeselected")?.withRenderingMode(.alwaysOriginal) else { return }
        firstItem.image = btnImageCurrencyDeselected
        
        guard let btnImageCurrency: UIImage = UIImage(named: "currency")?.withRenderingMode(.alwaysOriginal) else { return }
        firstItem.selectedImage = btnImageCurrency
        
        // MARK: - Second Item
        guard let secondItem = tabBar.items?[1] else { return }
        
        guard let btnImageTranslateDeselected: UIImage = UIImage(named: "translateDeselected")?.withRenderingMode(.alwaysOriginal) else { return }
        secondItem.image = btnImageTranslateDeselected
        
        guard let btnImageTranslate: UIImage = UIImage(named: "translate")?.withRenderingMode(.alwaysOriginal) else { return }
        secondItem.selectedImage = btnImageTranslate
        
        // MARK: - Third Item
        guard let thirdItem = tabBar.items?[2] else {
            return
        }
        
        guard let btnImageWeatherDeselected: UIImage = UIImage(named: "weatherDeselected")?.withRenderingMode(.alwaysOriginal) else { return }
        thirdItem.image = btnImageWeatherDeselected
        
        guard let btnImageWeather: UIImage = UIImage(named: "weather")?.withRenderingMode(.alwaysOriginal) else { return }
        thirdItem.selectedImage = btnImageWeather
        
        // MARK: - Custom text color for TabBar
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "tabBarNormalTextColor") as Any]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "tabBarSelectedTextColor") as Any]

        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance

        tabBar.standardAppearance = tabBarAppearance
    }
}
