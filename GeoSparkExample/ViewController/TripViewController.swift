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
    var activityIndicator:ActivityIndicator?
    var trips:[ActiveTripsResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = ActivityIndicator(view: self.view)
        let nib = UINib(nibName: "TripsTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "TripsTableViewCell")
        
        loadData()
    }
    
    static public func viewController() -> TripViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "TripViewController") as! TripViewController
        return logsDisplayVC
    }
    
    func loadData(){
        DispatchQueue.main.async{
            self.activityIndicator?.showActivityIndicator()
        }
        GeoSpark.activeTrips({ (trip) in
            self.trips = trip.trips
            DispatchQueue.main.async{
                self.activityIndicator?.stopActivityIndicator()
                self.tableview.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async{
                self.activityIndicator?.stopActivityIndicator()
                self.tableview.reloadData()
                self.alert(error.errorCode, error.errorMessage)
            }
        }
    }
    
    
}
extension TripViewController:UITableViewDelegate,UITableViewDataSource,TripsTableViewCelldelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell") as? TripsTableViewCell
        let trip = trips[indexPath.row]
        if trip.isStarted == true {
            cell?.endTripBtn.setTitle("END", for: .normal)
        }else{
            cell?.endTripBtn.setTitle("START", for: .normal)
        }
        cell?.userId.text = trip.trip_id
        cell?.timeLable.text = trip.updatedAt.UTCToLocal()
        cell?.cellDelegate = self
        return cell!
    }
    
    func alert(_ title:String,_ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func didChangeSwitchState(_ sender: TripsTableViewCell) {
        print("didChangeSwitchState",sender)
        let indexPath = self.tableview.indexPath(for: sender)
        let trip = self.trips[(indexPath?.row)!]
        
        if sender.endTripBtn.titleLabel?.text! == "END"{
            GeoSpark.endTrip(trip.trip_id!, { (trip) in
                if trip.msg == "Trip Ended."{
                    self.loadData()
                }
            }) { (error) in
                DispatchQueue.main.async{
                    self.alert(error.errorCode, error.errorMessage)
                }
            }
        }else{
            GeoSpark.startTrip(trip.trip_id, "", { (trip) in
                if trip.msg! == "Trip Started Successfully."{
                    self.loadData()
                }
            }) { (error) in
                DispatchQueue.main.async{
                    self.alert(error.errorCode, error.errorMessage)
                }
            }
        }
    }
    
}

