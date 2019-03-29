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
    fileprivate let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        GeoSpark.intialize(PUBLISABLEKEY)
        GeoSpark.delegate = self
        GeoSpark.trackLocationInAppState([GSAppState.AlwaysOn])
        GeoSpark.trackLocationInMotion([GSMotion.All])
        GeoSpark.setLocationAccuracy(70)
        GeoSpark.enableLogger(true)
        registerForPushNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
        }

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
        GeoSpark.setDeviceToken(deviceToken)
    }
    
    func didUpdateLocation(_ location: GSLocation) {
        print(location.userId)
        Utils.saveLocationToLocal(location.latitude, longitude: location.longitude)
    }
    
    @objc func  reachabilityChanged(note: Notification)
    {
        let reachability = note.object as! Reachability

        if reachability.connection == .none {
            
        }else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connectNetwork"), object: nil, userInfo: nil)
        }
    }

}
