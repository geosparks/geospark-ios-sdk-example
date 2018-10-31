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
                GeoSpark.trackLocationInAppState([GSAppState.AlwaysOn])
            } else if index == 1 {
                GeoSpark.trackLocationInAppState([GSAppState.Terminated])
            }
            else if index == 2 {
                GeoSpark.trackLocationInAppState([GSAppState.Foreground])
            } else if index == 3 {
                GeoSpark.trackLocationInAppState([GSAppState.Background])
            } else {
                GeoSpark.trackLocationInAppState([GSAppState.AlwaysOn])
            }
            
        } else if multiSelectSegmentedControl.tag == 101 {
            if index == 0 {
                GeoSpark.trackLocationInMotion([GSMotion.All])
            } else if index == 1{
                GeoSpark.trackLocationInMotion([GSMotion.Running])
            }else if index == 2{
                GeoSpark.trackLocationInMotion([GSMotion.Walking])
            }else if index == 3{
                GeoSpark.trackLocationInMotion([GSMotion.AutoMotive])
            }else if index == 4{
                GeoSpark.trackLocationInMotion([GSMotion.Stationary])
            } else{
                GeoSpark.trackLocationInMotion([GSMotion.All])
            }
        }
    }
    

    
    @IBAction func defaultSetting(_ sender: Any) {
        defaultValue()
        print("Default Settings")
    }
    
    fileprivate func defaultValue(){
        appStateSegmentControl.selectedSegmentIndex = 0
        motionSegmentControl.selectedSegmentIndex = 0
        GeoSpark.trackLocationInMotion([GSMotion.All])
        GeoSpark.trackLocationInAppState([GSAppState.AlwaysOn])
    }
    
}

