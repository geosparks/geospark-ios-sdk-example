//
//  LogViewController.swift
//  TestSDK
//
//  Created by GeoSpark Mac #1 on 17/12/18.
//  Copyright © 2018 GeoSpark, Inc. All rights reserved.
//

import UIKit

class LogViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var contentTableView: UITableView!
    var isServer:Bool = true
    var activityIndicator:ActivityIndicator?
    var dataCount:[Dictionary<String,Any>] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = ActivityIndicator(view: self.view)
        self.contentTableView.estimatedRowHeight = 44.0
        self.contentTableView.rowHeight = UITableView.automaticDimension
        serverLogs()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    static public func viewController() -> LogViewController {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "LogViewController") as! LogViewController
                return logsDisplayVC
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isServer{
            return dataCount.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell") as? LogTableViewCell
        
        let dic:Dictionary<String,Any> = dataCount[indexPath.row]
        cell?.secondLabel.text = (dic["response"] as! String)
        cell?.firstLabel?.text = (dic["timeStamp"] as! String)
        return cell!
    }
    

    func serverLogs(){
        let dataArray = UserDefaults.standard.array(forKey: "savelocationServerLogs")
        if dataArray?.count != 0 && dataArray != nil{
            dataCount = dataArray as! [Dictionary<String,Any>]
            DispatchQueue.main.async {
                self.dataCount = self.dataCount.reversed()
                self.contentTableView.reloadData()
            }
        }
    }
    
}
