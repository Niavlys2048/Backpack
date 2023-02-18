//
//  AppDelegate.swift
//  Backpack
//
//  Created by Sylvain Druaux on 24/01/2023.
//

// https://stackoverflow.com/questions/59006550/how-to-remove-scene-delegate-from-ios-application

import UIKit
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // https://developers.google.com/maps/documentation/places/ios-sdk/config#use-cocoapods
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String, !apiKey.isEmpty else {
            print("Error: Missing Google API key")
            return false
        }
        
        GMSPlacesClient.provideAPIKey(apiKey)
        
        return true
    }
}
