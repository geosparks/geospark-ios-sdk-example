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
    var userIds:[GeoSparkTripsData] = []
    var isTripBool:Bool = false
    
    var activityIndicator:ActivityIndicator?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = ActivityIndicator(view: self.view)
        let nib = UINib(nibName: "TripsTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "TripsTableViewCell")
    }
    

    static public func viewController() -> TripViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "TripViewController") as! TripViewController
        return logsDisplayVC
    }
    

    @IBAction func startTrip(){
        activityIndicator?.showActivityIndicator()
        isTripBool = false
        GeoSpark.startTrip({ (trip) in
            print(trip.tripId)
            DispatchQueue.main.async{
                self.activityIndicator?.stopActivityIndicator()
                self.tableview.reloadData()
            }
        }, onFailure: { (error) in
            print(error)
        })
    }
    
    @IBAction func activeTrip(){
        isTripBool = true
        activeTripValue()
    }

    func activeTripValue(){
        activityIndicator?.showActivityIndicator()
        GeoSpark.activeTrips({ (trips) in
            print(trips)
            self.userIds = trips.data
            DispatchQueue.main.async{
                
                self.activityIndicator?.stopActivityIndicator()
                self.tableview.reloadData()
            }

        }, onFailure: { (error) in
            print(error)
        })
    }
}

extension TripViewController: UITableViewDelegate, UITableViewDataSource,TripsTableViewCelldelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell") as? TripsTableViewCell
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
        activityIndicator?.showActivityIndicator()
        GeoSpark.endTrip(tripId, { (tripInfo) in
            self.activeTripValue()
        }, onFailure: { (error) in
            
        })

    }

}
