//
//  GetCurrentLocationViewController.swift
//  TestSDK
//
//  Created by GeoSpark Mac #1 on 24/01/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import MapKit
import GeoSpark
import CoreLocation

class GetCurrentLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label1: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    static public func viewController() -> GetCurrentLocationViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "GetCurrentLocationViewController") as! GetCurrentLocationViewController
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

    func zoomToRegion(_ location:CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        
        mapView.setRegion(region, animated: true)
    }

    @IBAction func selectDate(){
        showHud()
        GeoSpark.getCurrentLocation(100) { (location) in
            let coord = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            self.zoomToRegion(coord)
            self.addAnnotations(coords: coord, acc: location.accuracy)
            self.label.text = "\("Longitude     ")\(location.longitude)"
            self.label1.text = "\("Latitude     ")\(location.latitude)"
            print("longitude",location.longitude)
            print("latitude",location.latitude)
            DispatchQueue.main.async {
                self.dismissHud()
            }
        }
    }
    
    func addAnnotations(coords:CLLocationCoordinate2D,acc:Double){
            let anno = MKPointAnnotation();
            anno.coordinate = coords;
            anno.title  = String(acc)
            mapView.addAnnotation(anno);
    }

}
