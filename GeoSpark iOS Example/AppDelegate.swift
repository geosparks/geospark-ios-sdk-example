//
//  AppDelegate.swift
//  GeoSpark iOS Example
//
//  Created by Vignesh Shiva on 23/10/17.
//  Copyright © 2017 Vignesh Shiva. All rights reserved.
//

import UIKit
import GeoSpark
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    let geoSparkManager = GeoSpark.sharedInstance
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        geoSparkManager.intialize("YOUR-SDK-KEY",apiSecret:"YOUR-SECRET",application: application)
        registerForPushNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        GeoSpark.sharedInstance.didRegisterForRemoteNotificationsWithDeviceToken(token)
    }
    
    
}
