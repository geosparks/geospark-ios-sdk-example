//
//  MapViewController.swift
//  TestExample
//
//  Created by GeoSpark Mac #1 on 10/08/18.
//  Copyright © 2018 GeoSpark, Inc. All rights reserved.
//

import UIKit
import MapKit

class  MapViewController: UIViewController,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var locations: [[String: Any]]?
    let annotation = MKPointAnnotation()
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var last:CLLocationCoordinate2D?
    
    static public func viewController() -> MapViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        return logsDisplayVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data  = UserDefaults.standard.array(forKey: "GeoSparkKeyForLatLongInfo") as? [[String:Any]]
        if  data != nil{
            let annotations = getMapAnnotations(data!)
            mapView.addAnnotations(annotations)
            
            
            for annotation in annotations {
                points.append(annotation.coordinate)
                if (annotations.last != nil){
                    last = CLLocationCoordinate2D(latitude: (annotations.last?.latitude)!, longitude: (annotations.last?.longitude)!)
                    zoomToRegion(last!)
                }
            }
            
            let polyline = MKPolyline(coordinates: &points, count: points.count)
            mapView.add(polyline)

        }
    }
    
    func zoomToRegion(_ location:CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        mapView.setRegion(region, animated: true)
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    //MARK:- Annotations
    
    func getMapAnnotations(_ dict:[[String:Any]]) -> [Station] {
        var annotations:Array = [Station]()
        
        for item in dict.enumerated() {
            let locDict = item.element
            let lat = locDict["latitude"] as! Double
            let long = locDict["longitude"] as! Double
            let annotation = Station(latitude: lat, longitude: long)
            annotation.title = locDict["timeStamp"] as? String
            annotations.append(annotation)
        }
        return annotations
    }
}

class Station: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

