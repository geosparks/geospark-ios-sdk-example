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

    override func viewDidLoad() {
        super.viewDidLoad()
        GeoSpark.geofenceList({ (geofenceList) in
            self.dataArray = geofenceList.data
            DispatchQueue.main.async {
                self.contentTableView.reloadData()
            }
        }, onFailure: { (error) in
            print(error)
        })
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

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.count == 0 {
            self.contentTableView.setEmptyMessage("No geofence created")
        } else {
            self.contentTableView.restore()
        }
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "logsCell", for: indexPath)
        tableViewCell.textLabel?.text = dataArray[indexPath.row].geofenceId
        tableViewCell.detailTextLabel?.text = dataArray[indexPath.row].geofenceId
        return tableViewCell
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
