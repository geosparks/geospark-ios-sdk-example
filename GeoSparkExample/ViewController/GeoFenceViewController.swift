//
//  GeoFenceViewController.swift
//  TestSDK
//
//  Created by GeoSpark Mac #1 on 23/10/18.
//  Copyright © 2018 GeoSpark, Inc. All rights reserved.
//

import UIKit
import MapKit
import GeoSpark

class GeoFenceViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radius: UITextField!
    @IBOutlet weak var expiry: UITextField!
    var isLocationupdated:Bool = true

    var selectedCoordinate:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.mapType = .standard
        mapView.delegate = self
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }

        addLongPressGesture()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        radius.resignFirstResponder()
        expiry.resignFirstResponder()
    }
    
    func addLongPressGesture(){
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
        self.mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.showsUserLocation = false
    }
    
    @objc func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        self.resetTracking()
        self.mapView.addAnnotation(annot)
        self.centerMap(touchMapCoordinate)
    }
    
    func resetTracking(){
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
    }

    func centerMap(_ center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpan(latitudeDelta: spanX, longitudeDelta: spanY))
        mapView.setRegion(newRegion, animated: true)
        selectedCoordinate = center
        
    }

    static public func viewController() -> GeoFenceViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "GeoFenceViewController") as! GeoFenceViewController
        return logsDisplayVC
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if isLocationupdated{
            isLocationupdated = false
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let myLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: myLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func create(_ sender: Any) {
        if radius.text?.isEmpty == true{
            print(radius.text!)
            alert("Geofence Radus", "Enter radius")
        } else if expiry.text?.isEmpty == true {
            print(expiry.text!)
            alert("Geofence expiry", "Enter expiry")
        } else if selectedCoordinate == nil{
            alert("Geofence", "select coordinate for creating geofence")
        }
        else {
            showHud()
            GeoSpark.createGeofence(latitude: (selectedCoordinate?.latitude)!, longitude: (selectedCoordinate?.longitude)!, expiry: Int(expiry!.text!)!, radius: Int(radius!.text!)!, { (geofence) in
                DispatchQueue.main.async{
                    self.dismissHud()
                    self.radius.text = ""
                    self.expiry.text = ""
                }
            }, onFailure: { (error) in
                DispatchQueue.main.async{
                    self.dismissHud()
    
                }
            })
        }
    }
    
    @IBAction func list(_ sender: Any) {

        let vc = GeofenceListViewController.viewController()
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func addRadiusCircle(location: CLLocation,radius:CLLocationDistance){
        DispatchQueue.main.async{
            self.mapView.delegate = self
            let circle = MKCircle(center: location.coordinate, radius: radius)
            self.mapView.addOverlay(circle)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.lineWidth = 1
            return circle
        } else {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
    }

    

}
extension GeoFenceViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func alert(_ title:String,_ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
