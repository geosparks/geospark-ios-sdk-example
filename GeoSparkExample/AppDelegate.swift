//
//  AppDelegate.swift
//  GeoSpark iOS Example
//


import UIKit
import GeoSpark
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,GeoSparkDelegate{
    
    
    var window: UIWindow?
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GeoSpark.sharedInstance.intialize("YOUR-SDK-KEY",apiSecret:"YOUR-SECRET");
        GeoSpark.sharedInstance.delegate  = self
        GeoSpark.sharedInstance.setLocationMode(GSLocation.Best)
        GeoSpark.sharedInstance.setDistanceFilter(GS.High)
        GeoSpark.sharedInstance.setLocationFrequency(GS.High)
        GeoSpark.sharedInstance.setLocationAccuracy(GS.Low)
        GeoSpark.sharedInstance.trackLocationInAppState([GSAppState.AlwaysOn])
        GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.All])

        registerForPushNotifications()

        return true
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        GeoSpark.sharedInstance.didFailToRegisterForRemoteNotificationsWithError(error)
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
    
    func didUpdateLocation(_ location: CLLocation, user: GeoSparkUser) {
        print("\(location)")
    }

}
