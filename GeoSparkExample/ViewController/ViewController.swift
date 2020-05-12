//
//  ViewController.swift
//  GeoSpark iOS Example
//


import UIKit
import GeoSpark
import CoreLocation

class ViewController: UIViewController {
    

    
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var setDescriptionButton: UIButton!
    @IBOutlet weak var getUserButton: UIButton!
    @IBOutlet weak var requestLocationButton: UIButton!
    @IBOutlet weak var requestMotionButton: UIButton!
    @IBOutlet weak var stopTrackingButton: UIButton!
    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var tripsButton: UIButton!
    @IBOutlet weak var showCurrentLocationButton: UIButton!
    @IBOutlet weak var trackedLocation: UIButton!
    @IBOutlet weak var updatedLocation: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var userIdField: UITextField!
    @IBOutlet weak var userDescField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHud()
        
        if UserDefaultsValue.getDefaultString("UserId").isEmpty == false{
            resetDefaultButton(true)
            self.userIdField.text = UserDefaultsValue.getDefaultString("UserId")
            if UserDefaultsValue.getDefaultString("appUserName").isEmpty == false{
                self.userDescField.text = UserDefaultsValue.getDefaultString("appUserName")
            }
        }else{
            resetDefaultButton(false)
        }
        
        dismissHud()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUser(_ sender: Any) {
        showHud()
        var userDes:String = ""
        if userDescField.text?.isEmpty == false {
            userDes = userDescField.text!
        }
        GeoSpark.createUser(userDes, { (user) in
            if user.userId.isEmpty == false{
                DispatchQueue.main.async {
                    UserDefaultsValue.setDefaultString(user.userId, "UserId")
                    self.userIdField.text = user.userId
                    if userDes.isEmpty == false {
                        self.userDescField.text = userDes
                        UserDefaultsValue.setDefaultString(userDes, "appUserName")
                    }
                    self.resetDefaultButton(true)
                    self.dismissHud()
                }
            }
        }) { (error) in
            self.defaultError(error)
        }
        
    }
    
    @IBAction func setDescription(_ sender: Any) {
        if userDescField.text?.isEmpty == false {
            showHud()
            var userDes:String = ""
            userDes = userDescField.text!
            GeoSpark.setDescription(userDes, { (user) in
                if user.userId.isEmpty == false{
                    DispatchQueue.main.async {
                        self.userDescField.text = userDes
                        UserDefaultsValue.setDefaultString(userDes, "UserId")
                        self.resetDefaultButton(true)
                        self.dismissHud()
                    }
                }
                
            }) { (error) in
                self.defaultError(error)
            }
        }else{
            self.alert("Error", "Please enter Description for user")
        }
    }
    
    @IBAction func getUser(_ sender: Any) {
        if userIdField.text?.isEmpty == false{
            showHud()
            GeoSpark.getUser(userIdField.text!, { (user) in
                if user.userId.isEmpty == false{
                    DispatchQueue.main.async {
                        UserDefaultsValue.setDefaultString(user.userId, "UserId")
                        self.userIdField.text = user.userId
                        self.resetDefaultButton(true)
                        self.dismissHud()
                    }
                }
            }) { (error) in
                self.defaultError(error)
            }
        }else{
            self.alert("Error", "Please provide user Id")
        }
    }
    
    @IBAction func requestLocation(_ sender: Any) {
        if GeoSpark.isLocationEnabled() == false && CLLocationManager.locationServicesEnabled(){
            GeoSpark.requestLocation()
            requestLocationButton.isEnabled = false
        }else{
            self.alert("Check", "location is not enable")
        }
        
    }
    
    @IBAction func requestMotion(_ sender: Any) {
        if GeoSpark.isMotionEnabled() == false{
            GeoSpark.requestMotion()
        }
        requestMotionButton.isEnabled = false
    }
    
    @IBAction func StartTracking(_ sender: Any) {
        if GeoSpark.isLocationEnabled() == false {
            self.alert("Tracking", "locatiob is not enable")
        } else if GeoSpark.isMotionEnabled() == false{
            self.alert("Tracking", "Motion is not enable")
        }else{
            if UserDefaultsValue.getDefaultBoolean(kIsTracking) == false && CLLocationManager.locationServicesEnabled(){
                GeoSpark.startTracking(.highPerformance)
                UserDefaultsValue.setDefaultBoolean(true, kIsTracking)
                startTrackingButton.isEnabled = false
                stopTrackingButton.isEnabled = true
            }else{
                self.alert("Checking", "location is not enable")
            }
        }
    }
    
    @IBAction func stopTracking(_ sender: Any) {
        GeoSpark.stopTracking()
        UserDefaultsValue.setDefaultBoolean(false, kIsTracking)
        startTrackingButton.isEnabled = true
        stopTrackingButton.isEnabled = false
    }
    
    @IBAction func trips(_ sender: Any) {
        let vc = TripViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func currentLocation(_ sender: Any) {
        let vc = GetCurrentLocationViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func trackedLocation(_ sender: Any) {
        let vc = MapViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updatedLocation(_ sender: Any) {
        showHud()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            GeoSpark.updateCurrentLocation(30)
            self.dismissHud()
        })
    }

    @IBAction func logout(_ sender: Any) {
        showHud()
        GeoSpark.logout({ (userId) in
            if userId.isEmpty == false{
                DispatchQueue.main.async {
                    Utils.resetDefaults()
                    self.resetDefaultButton(false)
                    self.userDescField.text = ""
                    self.userIdField.text = ""
                    self.dismissHud()
                }
            }
        }) { (error) in
            self.dismissHud()
            self.alert(error.errorCode, error.errorMessage)
        }
    }
    
    func resetDefaultButton(_ isValue:Bool){
        self.createUserButton.isEnabled = !isValue
        self.getUserButton.isEnabled = !isValue
        
        self.setDescriptionButton.isEnabled = isValue
        self.requestLocationButton.isEnabled = isValue
        self.requestMotionButton.isEnabled = isValue
        self.startTrackingButton.isEnabled = isValue
        self.stopTrackingButton.isEnabled = isValue
        self.tripsButton.isEnabled = isValue
        self.showCurrentLocationButton.isEnabled = isValue
        self.trackedLocation.isEnabled = isValue
        self.updatedLocation.isEnabled = isValue
        self.logoutButton.isEnabled = isValue
        
        if isValue == true {
            self.enableButton()
        }
    }
    
    func enableButton(){
        if GeoSpark.isLocationEnabled(){
            requestLocationButton.isEnabled = false
        }
        if GeoSpark.isMotionEnabled(){
            requestMotionButton.isEnabled = false
        }
        if UserDefaultsValue.getDefaultBoolean(kIsTracking) == true {
            self.startTrackingButton.isEnabled = false
            self.stopTrackingButton.isEnabled = true
        }else{
            GeoSpark.startTracking(.highPerformance)
            self.startTrackingButton.isEnabled = true
            self.stopTrackingButton.isEnabled = false
        }
        
    }
    
    func defaultError(_ error:GeoSparkError){
        DispatchQueue.main.async {
            self.dismissHud()
            self.alert(error.errorCode, error.errorMessage)
        }
    }
    
    func alert(_ title:String,_ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension Notification.Name {
    static let locationUpdated = Notification.Name("locationUpdated")
}

