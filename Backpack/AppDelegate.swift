//
//  AppDelegate.swift
//  Backpack
//
//  Created by Sylvain Druaux on 24/01/2023.
//

import UIKit
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        lazy var appConfiguration = AppConfiguration()
        let apiKey = appConfiguration.googleApiKey
        GMSPlacesClient.provideAPIKey(apiKey)
        
        return true
    }
}
