//
//  ViewController.swift
//  GeoSpark iOS Example
//
//  Created by Vignesh Shiva on 23/10/17.
//  Copyright © 2017 Vignesh Shiva. All rights reserved.
//

import UIKit
import GeoSpark
import CoreLocation

class ViewController: UIViewController, GeoFencingProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var clearSessionButton: UIButton!
    @IBOutlet weak var startSessionButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    
    @IBOutlet weak var stopMonitoringButton: UIButton!
    @IBOutlet weak var startMonitoringButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GeoSpark.sharedInstance.geoFencingDelegate = self
        setupIntialStateForButtons()
        logInIfNeeded()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    @IBAction func createUser() {
        showHud()
        GeoSpark.sharedInstance.createUser { (success, error, errorCode, userID) in
            self.dismissHud()
            self.textField.text = userID
            self.enableLocationTracking()

        }
    }
    
    @IBAction func clearSession() {
        textField.text = ""
        GeoSpark.sharedInstance.clearSession()
        setupIntialStateForButtons()
        
    }
    
    func logInIfNeeded() {
        showHud()
        GeoSpark.sharedInstance.startSessionIfNeeded{(success, error, errorCode, userID) in
            self.dismissHud()
            if success {
                self.textField.text = userID
                self.enableLocationTracking()
            }
        }
    }
    
    
    
    @IBAction func startSession() {
        if textField.text != "" {
            let userID = textField.text!
            showHud()
            GeoSpark.sharedInstance.startSessionForUser(userID, completion : {(success, error, errorCode, userID) in
                self.dismissHud()
                self.enableLocationTracking()

            })
        }else{
            let alertController = UIAlertController(title: "Error", message: "Please enter User Id", preferredStyle: .alert)
            let destructionButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(destructionButton)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func enableLocationTracking() {
        createUserButton.isEnabled = false
        startSessionButton.isEnabled = false
        startMonitoringButton.isEnabled = true
        clearSessionButton.isEnabled = true
        if UserDefaults.standard.bool(forKey: "isGeoSparkTrackingEnabled") {
            startLocationTracking()
        }
    }
    
    func setupIntialStateForButtons() {
        let buttonArray : [UIButton] = [startSessionButton, createUserButton, stopMonitoringButton, startMonitoringButton,clearSessionButton]
        for button in buttonArray {
            button.isEnabled = false
        }
        startSessionButton.isEnabled = true
        createUserButton.isEnabled = true
    }
    
    @IBAction func startLocationTracking() {
        GeoSpark.sharedInstance.startLocationTracking()
        startMonitoringButton.isEnabled = false
        stopMonitoringButton.isEnabled = true
    }
    
    
    @IBAction func stopLocationTracking() {
        GeoSpark.sharedInstance.stopLocationTracking()
        startMonitoringButton.isEnabled = true
        stopMonitoringButton.isEnabled = false
    }
    
    func locationAccessDenied() {
        
    }

    func didUpdateLocation(_ location : CLLocation, speed : Double) {
        NotificationCenter.default.post(name: .locationUpdated, object: location)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func viewLogs() {
        let vc = LogsDisplayViewController.viewController()
        vc.dataArray = logDetails()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewLatLong() {
        let vc = LogsDisplayViewController.viewController()
        vc.dataArray = locationDetails()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func logDetails() -> [[String : String]] {
        if let dataArray = UserDefaults.standard.array(forKey: GeoSparkKeyForLogsInfo){
            return dataArray as! [[String : String]]
        }
        return []
    }
    
    func locationDetails() -> [[String : String]] {
        var arrayToReturn : [[String : String]] = []
        if let dataArray = UserDefaults.standard.array(forKey: GeoSparkKeyForLatLongInfo){
            for anyObject in dataArray {
                if let locationInfo = anyObject as? [String : AnyObject], let latitude = locationInfo["latitude"] as? Double, let longitude = locationInfo["longitude"] as? Double, let timeStamp = locationInfo["timeStamp"] as? String {
                    let detailDict = ["log" : "lat : \(latitude) , long : \(longitude)", "timeStamp" : timeStamp]
                    arrayToReturn.append(detailDict)
                }
            }
        }
        arrayToReturn.reverse()
        return arrayToReturn
    }
}

extension Notification.Name {
    static let locationUpdated = Notification.Name("locationUpdated")
}
