//
//  LogsDisplayViewController.swift
//  GeoSparkExample
//
//  Created by Vignesh Shiva on 23/10/17.
//  Copyright © 2017 Vignesh Shiva. All rights reserved.
//

import UIKit

class LogsDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    var dataArray : [[String : String]] = []
    
    static public func viewController() -> LogsDisplayViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "logsDisplayVC") as! LogsDisplayViewController
        return logsDisplayVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "logsCell", for: indexPath)
        tableViewCell.textLabel?.text = dataArray[indexPath.row]["log"]
        tableViewCell.detailTextLabel?.text = dataArray[indexPath.row]["timeStamp"]
        return tableViewCell
    }

}
