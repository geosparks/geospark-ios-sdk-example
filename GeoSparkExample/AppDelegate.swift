//
//  AppDelegate.swift
//  GeoSpark iOS Example
//


import UIKit
import GeoSpark
import UserNotifications

let PUBLISABLEKEY = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,GeoSparkDelegate{
    
    
    var window: UIWindow?
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        GeoSpark.intialize(PUBLISABLEKEY)
        GeoSpark.delegate = self
        GeoSpark.trackLocationInAppState([GSAppState.AlwaysOn])
        GeoSpark.trackLocationInMotion([GSMotion.All])
        GeoSpark.setLocationAccuracy(70)
        
        registerForPushNotifications()

        return true
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
        print("deviceToken",deviceToken)
        GeoSpark.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func didUpdateLocation(_ location: GSLocation) {
        Utils.saveLocationToLocal(location.latitude, longitude: location.longitude)
    }

}
