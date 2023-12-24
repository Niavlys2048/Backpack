//
//  AppDelegate.swift
//  Backpack
//
//  Created by Sylvain Druaux on 24/01/2023.
//

import GooglePlaces
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold).rounded,
            NSAttributedString.Key.foregroundColor: UIColor(named: "titleColor"),
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key: Any]

        lazy var appConfiguration = AppConfiguration()
        let apiKey = appConfiguration.googleApiKey
        GMSPlacesClient.provideAPIKey(apiKey)

        return true
    }
}
