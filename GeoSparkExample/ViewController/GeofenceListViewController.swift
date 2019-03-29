//
//  GeofenceListViewController.swift
//  GeoSparkExample
//
//  Created by GeoSpark Mac #1 on 31/10/18.
//  Copyright © 2018 Geospark Inc. All rights reserved.
//

import UIKit
import GeoSpark

class GeofenceListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var contentTableView: UITableView!
    var dataArray:[GeoSparkGeofenceListData] = []
    var activityIndicator:ActivityIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = ActivityIndicator(view: self.view)
        
        let nib = UINib(nibName: "GeofenceListTableViewCell", bundle: nil)
        contentTableView.register(nib, forCellReuseIdentifier: "GeofenceListTableViewCell")
        
        activeGeofence()
    }
    
    static public func viewController() -> GeofenceListViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "GeofenceListViewController") as! GeofenceListViewController
        return logsDisplayVC
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    fileprivate func activeGeofence() {
        showHud()
        GeoSpark.geofenceList({ (geofenceList) in
            self.dataArray = geofenceList.data
            DispatchQueue.main.async {
                self.dismissHud()
                if geofenceList.data.count != 0{
                    let dict:Dictionary<String,Any> = ["name":"Geofence list","message": "\(geofenceList.data.count)"]
                    Utils.saveLogs(dict)
                }
                self.activityIndicator?.stopActivityIndicator()
                self.contentTableView.reloadData()
            }
        }, onFailure: { (error) in
            print(error)
            DispatchQueue.main.async {
                self.dismissHud()
                let dict:Dictionary<String,Any> = ["name":"Geofence list","message": error.errorMessage]
                Utils.saveLogs(dict)
                
                self.activityIndicator?.stopActivityIndicator()
            }
        })
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.count == 0 {
            self.contentTableView.setEmptyMessage("No geofence created")
        } else {
            self.contentTableView.restore()
        }
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeofenceListTableViewCell") as? GeofenceListTableViewCell
        cell?.userId.text = dataArray[indexPath.row].geofenceId
        cell?.timeLable.text = dataArray[indexPath.row].createdAt
        cell?.cellDelegate = self
        return cell!
    }
}

extension GeofenceListViewController: GeofenceListTableViewDelegate{
    
    func didChangeSwitchState(_ sender: GeofenceListTableViewCell) {
        let indexPath = self.contentTableView.indexPath(for: sender)
        deleteGeofence(dataArray[indexPath!.row].geofenceId)
    }
    
    func deleteGeofence(_ id:String){
        showHud()
        GeoSpark.deleteGeofence(id, { (string) in
            if string.isEmpty == false {
                let dict:Dictionary<String,Any> = ["name":"Delete Geofence","message": string]
                Utils.saveLogs(dict)
                
            }
            DispatchQueue.main.async {
                self.dismissHud()
                self.activityIndicator?.stopActivityIndicator()
                self.activeGeofence()
            }
            
        }) { (error) in
            let dict:Dictionary<String,Any> = ["name":"Delete Geofence","message": error.errorMessage]
            Utils.saveLogs(dict)
            DispatchQueue.main.async {
                self.dismissHud()
                self.activityIndicator?.stopActivityIndicator()
            }
        }
    }
    
}
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Avenir Heavy", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

