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
        
        // Custom images for TabBar
        // https://stackoverflow.com/questions/69794613/tabbar-custom-button-image-doesnt-show-up
        // https://stackoverflow.com/questions/29874499/tabbaritems-and-setting-their-image-sizes
        let btnImageCurrencyDeselected: UIImage! = UIImage(named: "currencyDeselected")!.withRenderingMode(.alwaysOriginal)
        (tabBar.items![0]).image = btnImageCurrencyDeselected
        
        let btnImageCurrency: UIImage! = UIImage(named: "currency")!.withRenderingMode(.alwaysOriginal)
        (tabBar.items![0]).selectedImage = btnImageCurrency
        
        let btnImageTranslateDeselected: UIImage! = UIImage(named: "translateDeselected")!.withRenderingMode(.alwaysOriginal)
        (tabBar.items![1] ).image = btnImageTranslateDeselected
        
        let btnImageTranslate: UIImage! = UIImage(named: "translate")!.withRenderingMode(.alwaysOriginal)
        (tabBar.items![1] ).selectedImage = btnImageTranslate
        
        let btnImageWeatherDeselected: UIImage! = UIImage(named: "weatherDeselected")!.withRenderingMode(.alwaysOriginal)
        (tabBar.items![2] ).image = btnImageWeatherDeselected
        
        let btnImageWeather: UIImage! = UIImage(named: "weather")!.withRenderingMode(.alwaysOriginal)
        (tabBar.items![2] ).selectedImage = btnImageWeather
        
        // Custom text color for TabBar
        // https://developer.apple.com/forums/thread/682528
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "tabBarNormalTextColor") as Any]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "tabBarSelectedTextColor") as Any]

        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance

        tabBar.standardAppearance = tabBarAppearance
//        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
