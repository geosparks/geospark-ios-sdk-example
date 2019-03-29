//
//  TripViewController.swift
//  TestSDK
//
//  Created by GeoSpark Mac #1 on 23/10/18.
//  Copyright © 2018 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark

class TripViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var seeTripDesc: UITextField!

    var userIds:[GeoSparkTripsData] = []
    var isTripBool:Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TripsTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "TripsTableViewCell")
    }
    

    static public func viewController() -> TripViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "TripViewController") as! TripViewController
        return logsDisplayVC
    }
    

    @IBAction func startTrip(){
        showHud()
        isTripBool = false

        var descStr:String = ""
        if (seeTripDesc.text?.isEmpty)!{
            descStr = ""
        }else {
            descStr = seeTripDesc.text!
        }
        
        GeoSpark.startTrip(descStr, { (trip) in
            DispatchQueue.main.async{
                self.dismissHud()
                self.seeTripDesc.text = ""
                self.alert("Trip Started for", trip.tripId)
            }

        }, onFailure: {(error) in
            DispatchQueue.main.async{
                self.dismissHud()
                self.tableview.reloadData()
            }
        })
    }
    
    @IBAction func activeTrip(){
        isTripBool = true
        activeTripValue()
    }

    func activeTripValue(){
        showHud()
        GeoSpark.activeTrips({ (trips) in
            self.userIds = trips.data.reversed()
            DispatchQueue.main.async{
                self.dismissHud()
                self.tableview.reloadData()
            }

        }, onFailure: { (error) in
            DispatchQueue.main.async{
                self.dismissHud()
                self.tableview.reloadData()
            }
        })
    }
}

extension TripViewController: UITableViewDelegate, UITableViewDataSource,TripsTableViewCelldelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell") as? TripsTableViewCell
        if userIds[indexPath.row].tripDescription == nil{
            cell?.userDescription.text = "No Description"
        }else {
            cell?.userDescription.text = userIds[indexPath.row].tripDescription
        }
        cell?.userId.text = userIds[indexPath.row].tripId
        cell?.timeLable.text = userIds[indexPath.row].tripStartedAt
        cell?.cellDelegate = self
        return cell!
    }
    
    func didChangeSwitchState(_ sender: TripsTableViewCell) {
        print("didChangeSwitchState",sender)
        let indexPath = self.tableview.indexPath(for: sender)
        endTrip(userIds[indexPath!.row].tripId)
    }
    
    func endTrip(_ tripId:String){
        showHud()
        GeoSpark.endTrip(tripId, { (tripInfo) in
            self.activeTripValue()
            DispatchQueue.main.async{
                self.dismissHud()
                self.tableview.reloadData()
            }

        }, onFailure: { (error) in
            DispatchQueue.main.async{
                self.dismissHud()
                self.tableview.reloadData()
            }
        })

    }
    
    func alert(_ title:String,_ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}
extension TripViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
