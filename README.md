# GeoSpark iOS SDK Example

An example app for iOS which implements the GeoSpark SDK and shows your location history.

## Example App

### To get started:

Download this project and open it in Xcode.

1. Clone or download the project.

2. [Request](https://geospark.co) for a GeoSpark developer account to get your SDK key and Secret.

3. Open the `GeoSparkExample.xcodeproj` file. In the  `AppDelegate.m`, update this line `GeoSpark.sharedInstance.initialize(”YOUR-SDK-KEY”,apiSecret:”YOUR-SECRET”,application: application);` to contain your GeoSpark SDK key and Secret.

4. Replace with your bundle identifier.

Ready to deploy! 

Your iOS app is all set. As your users update and log in, their live location will be visualized on GeoSpark dashboard.


# Installation into your Application

Installing the GeoSpark SDK is done in 3 steps.

1. **Import and Initialize SDK**
2. **Capabilities and permissions**
3. **APNS Configurations**

### Import and Initialize SDK into your project

After downloading the SDK from [here](https://s3.amazonaws.com/geospark-framework/iOS/GeoSpark.zip), unzip and drag the GeoSpark.framework file into your project. Make sure it is included in your "Link Binary With Libraries" section of your target's Build Phases.

In your application delegate import the sdk. To initialize the SDK, you must call the GeoSpark.initialize method when your app is started.

```
Import GeoSpark
...
GeoSpark.sharedInstance.initialize(”YOUR-SDK-KEY”,apiSecret:”YOUR-SECRET”,application: application);
```

[Request](https://geospark.co) for SDK keys if you don't have already.


### Capabilities and permissions

Go to the capabilities tab in your app settings, scroll to background modes and switch it on. Select `Location updates`, `Background fetch` and `Remote notifications`.

To add permission strings to your `Info.plist`, go to the Info tab in your app settings and add permission strings for

```
Privacy - Location Always Usage Description
Privacy - Location Always and When In Use Usage Description
Privacy - Location When In Use Usage Description
```


The SDK is only compatible with the `Location - Always permissions`. You can use the included utility methods to request permission, in case you feel the need to.

```
GeoSpark.requestAlwaysAuthorization()
```


### APNS Configurations

1. Log into the GeoSpark dashboard, and open your `Settings->Add Certs`. Upload your APNS development or distribution certificates (.p12 files).
2. In the app capabilities, ensure that remote notifications inside background modes is enabled.
3. The following changes inside `AppDelegate` will register the SDK for push notifications and route GeoSpark notifications to the SDK.

Inside `didFinishLaunchingWithOptions`, use the SDK method to register for notifications.

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    ...
    GeoSpark.registerForNotifications()
}
```

Inside and `didRegisterForRemoteNotificationsWithDeviceToken` and `didFailToRegisterForRemoteNotificationsWithError` methods, add the relevant lines so that GeoSpark can register the device token.

```
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    ...
    GeoSpark.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
}

func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    ...
    GeoSpark.didFailToRegisterForRemoteNotificationsWithError(error: error)
}
```

Inside the `didReceiveRemoteNotification` method, add the GeoSpark receiver. This method parses only the notifications that sent from GeoSpark.

```
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    if (GeoSpark.isGeoSparkNotification(userInfo: userInfo)){
        GeoSpark.didReceiveRemoteNotification(userInfo: userInfo)
    }

    // Do any additional handling for your app's notifications.
}
```

## Create User

The SDK needs an User ID object to identify the device. The SDK has a convenience method `createUser()` to create a user which returns User ID. 


```
//Create a User for given deviceToken on GeoSpark Server. 
GeoSpark.sharedInstance.createUser() { (userId, error) in
  if (error != nil) {
    // Handle createUser API error here
    ...
    return
  }

  if (userId != nil) {
    // Handle createUser API success here
    ...
  }
}        
```

## Get User

If you already have an User ID object. The SDK has a convenience method `getUser()` to to start the session for the existing user.

Method parameters

| Parameter    | Description |
|--------------|-------------|
| userID       | User ID from your API Server |

```
/**
*Implement your API call for User Login and get back a GeoSpark
*UserId from your API Server to be configured in the GeoSpark SDK
*along with deviceToken.
*/

GeoSpark.sharedInstance.getUser(userId) { (userId, error) in
  if (error != nil) {
    // Handle getUser API error here
    ...
    return
  }

  if (userId != nil) {
    // Handle getUser API success here
    ...
  }
}         
```

## Start Location Tracking

To start tracking the location, use the `startLocationTracking()` method. You can keep SDK to track location, or turn it off if you want to stop tracking the user at any point of time using the stopLocationTracking()  method.

```
GeoSpark.startLocationTracking()
```

## Stop Location Tracking

You can stop tracking the user at any point of time using the `stopLocationTracking()` method.

```
GeoSpark.stopLocationTracking()
```

## View Dashboard

Install your app with the GeoSpark SDK on a device and begin tracking on the Dashboard. You would see the user’s current state on the GeoSpark dashboard. If you click on the user, you should be able to view the user's location history.





