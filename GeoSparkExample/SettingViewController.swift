//
//  SettingViewController.swift
//  TestExample
//
//  Created by GeoSpark Mac #1 on 14/08/18.
//  Copyright © 2018 GeoSpark, Inc. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl
import GeoSpark

class SettingViewController: UIViewController,MultiSelectSegmentedControlDelegate{
    
    @IBOutlet weak var appStateSegmentControl: MultiSelectSegmentedControl!
    @IBOutlet weak var motionSegmentControl: MultiSelectSegmentedControl!
    @IBOutlet weak var distanceFilterSegmentControl: UISegmentedControl!
    @IBOutlet weak var LocationFrequencyControl: UISegmentedControl!
    @IBOutlet weak var LocationAccuracyControl: UISegmentedControl!
    @IBOutlet weak var LocationModeControl: UISegmentedControl!
    
    
    static public func viewController() -> SettingViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        return logsDisplayVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultValue()
        appStateSegmentControl.delegate = self
        motionSegmentControl.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func multiSelect(_ multiSelectSegmentedControl: MultiSelectSegmentedControl, didChangeValue value: Bool, at index: UInt) {
        print("multiSelectSegmentedControl",multiSelectSegmentedControl.tag,index)
        if multiSelectSegmentedControl.tag == 100 {
            if index == 0 {
                GeoSpark.sharedInstance.trackLocationInAppState([GSAppState.AlwaysOn])
            } else if index == 1 {
                GeoSpark.sharedInstance.trackLocationInAppState([GSAppState.Terminated])
            }
            else if index == 2 {
                GeoSpark.sharedInstance.trackLocationInAppState([GSAppState.Foreground])
                
            } else if index == 3 {
                GeoSpark.sharedInstance.trackLocationInAppState([GSAppState.Background])
            } else {
                GeoSpark.sharedInstance.trackLocationInAppState([GSAppState.AlwaysOn])
            }
            
        } else if multiSelectSegmentedControl.tag == 101 {
            if index == 0 {
                GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.All])
            } else if index == 1{
                GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.Running])
            }else if index == 2{
                GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.Walking])
                
            }else if index == 3{
                GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.AutoMotive])
            }else if index == 4{
                GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.Stationary])
            } else{
                GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.All])
            }
        }
    }
    
    
    @IBAction func distanceFilterAction(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        print("distanceFilterAction",segment.selectedSegmentIndex)
        if segment.selectedSegmentIndex == 0 {
            GeoSpark.sharedInstance.setDistanceFilter(GS.High)
        }else if segment.selectedSegmentIndex == 1 {
            GeoSpark.sharedInstance.setDistanceFilter(GS.Medium)
        }
        else if segment.selectedSegmentIndex == 2 {
            GeoSpark.sharedInstance.setDistanceFilter(GS.Low)
        } else {
            GeoSpark.sharedInstance.setDistanceFilter(GS.OPTIMISED)
        }
    }
    
    @IBAction func locationFrequencyAction(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        print("locationFrequencyAction",segment.selectedSegmentIndex)
        
        if segment.selectedSegmentIndex == 0 {
            GeoSpark.sharedInstance.setLocationFrequency(GS.High)
        }else if segment.selectedSegmentIndex == 1 {
            GeoSpark.sharedInstance.setLocationFrequency(GS.Medium)
        }
        else if segment.selectedSegmentIndex == 2 {
            GeoSpark.sharedInstance.setLocationFrequency(GS.Low)
        } else {
            GeoSpark.sharedInstance.setLocationFrequency(GS.OPTIMISED)
        }
        
    }
    
    @IBAction func locationAccuracy(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        print("locationAccuracy",segment.selectedSegmentIndex)
        if segment.selectedSegmentIndex == 0 {
            GeoSpark.sharedInstance.setLocationAccuracy(GS.High)
        }else if segment.selectedSegmentIndex == 1 {
            GeoSpark.sharedInstance.setLocationAccuracy(GS.Medium)
        }
        else if segment.selectedSegmentIndex == 2 {
            GeoSpark.sharedInstance.setLocationAccuracy(GS.Low)
        } else {
            GeoSpark.sharedInstance.setLocationAccuracy(GS.OPTIMISED)
        }
        
    }
    @IBAction func locationMode(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        print("locationMode",segment.selectedSegmentIndex)
        if segment.selectedSegmentIndex == 0 {
            GeoSpark.sharedInstance.setLocationMode(GSLocation.Best)
        } else if segment.selectedSegmentIndex == 1 {
            GeoSpark.sharedInstance.setLocationMode(GSLocation.BestForNavigation)
        }else if segment.selectedSegmentIndex == 2 {
            GeoSpark.sharedInstance.setLocationMode(GSLocation.NearestTenMeters)
        }else if segment.selectedSegmentIndex == 3 {
            GeoSpark.sharedInstance.setLocationMode(GSLocation.HundredMeters)
        }else if segment.selectedSegmentIndex == 4 {
            GeoSpark.sharedInstance.setLocationMode(GSLocation.ThreeKilometers)
        }else{
            GeoSpark.sharedInstance.setLocationMode(GS.OPTIMISED)
        }
    }
    
    @IBAction func defaultSetting(_ sender: Any) {
        defaultValue()
        print("Default Settings")
    }
    
    fileprivate func defaultValue(){
        appStateSegmentControl.selectedSegmentIndex = 0
        motionSegmentControl.selectedSegmentIndex = 0
        distanceFilterSegmentControl.selectedSegmentIndex = 3
        LocationFrequencyControl.selectedSegmentIndex = 3
        LocationAccuracyControl.selectedSegmentIndex = 3
        LocationModeControl.selectedSegmentIndex = 6
        GeoSpark.sharedInstance.setLocationMode(GS.OPTIMISED)
        GeoSpark.sharedInstance.setLocationAccuracy(GS.OPTIMISED)
        GeoSpark.sharedInstance.setLocationFrequency(GS.OPTIMISED)
        GeoSpark.sharedInstance.setDistanceFilter(GS.OPTIMISED)
        GeoSpark.sharedInstance.trackLocationInMotion([GSMotion.All])
        GeoSpark.sharedInstance.trackLocationInAppState([GSAppState.AlwaysOn])
    }
    
}

