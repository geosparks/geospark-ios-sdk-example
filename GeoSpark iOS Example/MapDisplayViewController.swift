//
//  MapDisplayViewController.swift
//  GeoSpark iOS Example
//
//  Created by Vignesh Shiva on 23/10/17.
//  Copyright © 2017 Vignesh Shiva. All rights reserved.
//

import UIKit
import MapKit
import GeoSpark

class MapDisplayViewController: UIViewController {
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    static public func viewController() -> MapDisplayViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mapDisplayVC = storyBoard.instantiateViewController(withIdentifier: "mapDisplayVC") as! MapDisplayViewController
        return mapDisplayVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setMapAnnotations()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation), name: .locationUpdated, object: nil)
    }

    func didUpdateLocation(_ notification: NSNotification) {
        if let _ = mapKitView, let location = notification.object as? CLLocation {
            centerMapOnLocation(location: location)
            let mapAnnotation = MKPointAnnotation()
            mapAnnotation.coordinate = location.coordinate
            mapKitView.addAnnotation(mapAnnotation)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }
    
    func setMapAnnotations() {
        if let dataArray = UserDefaults.standard.array(forKey: GeoSparkKeyForLatLongInfo){
            for anyObject in dataArray {
                if let locationInfo = anyObject as? [String : AnyObject], let latitude = locationInfo["latitude"] as? Double, let longitude = locationInfo["longitude"] as? Double {
                    let mapAnnotation = MKPointAnnotation()
                    mapAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    mapKitView.addAnnotation(mapAnnotation)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
