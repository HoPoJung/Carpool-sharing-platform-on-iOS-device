//
//  CarpoolViewController.swift
//  HackNTU_IOS_Project
//
//  Created by 何柏融 on 2016/12/21.
//  Copyright © 2016年 Peter. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class CarpoolViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    

    @IBOutlet weak var carpoolMapView: MKMapView!
    
    @IBOutlet weak var StartingAddress: UITextField!
    @IBOutlet weak var DestinationAddress: UITextField!
    let manager = CLLocationManager()
    
    var myLocations: [CLLocation] = []
    
    var startingPoint = CLLocationCoordinate2D()
    var endPoint = CLLocationCoordinate2D()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        carpoolMapView.userTrackingMode = .follow
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        self.carpoolMapView.delegate = self
        self.DestinationAddress.delegate = self
        self.StartingAddress.delegate = self
        
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location" + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        let goecoder = CLGeocoder()
        goecoder.reverseGeocodeLocation(location, completionHandler:{(placemarks, e) -> Void in
            if e != nil{
                print("Error: " + (e?.localizedDescription)!)
            }
            else{
                let placemark = (placemarks?.last)! as CLPlacemark
                let address: String = "\(placemark.name!) \(placemark.country!) \(placemark.administrativeArea!) \(placemark.subAdministrativeArea!) \(placemark.locality!)"
                self.startingPoint = location.coordinate
                self.StartingAddress.text = address
        }
    
        })
        
    }
    
//    @IBAction func EditFinalDestnation(_ sender: Any) {
//        let address = self.DestinationAddress.text!
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error:NSError?) -> Void in
//            if error != nil{
//                print(error)
//                return}
//            if placemarks != nil && (placemarks?.count)! > 0{
//                let placemark = (placemarks?[0])! as CLPlacemark
//                self.carpoolMapView.addAnnotation(MKPlacemark(placemark: placemark))
//            }
//            } as! CLGeocodeCompletionHandler)
//    }
    
    @IBAction func finishEditingLocation(_ sender: Any) {
        
        let location = CLLocation(latitude:25.020050, longitude:121.533870)
        
        self.addAnnotation(location: location)
        let goecoder = CLGeocoder()
        goecoder.reverseGeocodeLocation(location, completionHandler:{(placemarks, e) -> Void in
            if e != nil{
                print("Error: " + (e?.localizedDescription)!)
            }
            else{
                let placemark = (placemarks?.last)! as CLPlacemark
                let address: String = "\(placemark.name!) \(placemark.country!) \(placemark.administrativeArea!) \(placemark.subAdministrativeArea!) \(placemark.locality!)"
                print(address)
                self.endPoint = location.coordinate
                self.DestinationAddress.text = address
            }
            
        })
        let sourcePlaceMark = MKPlacemark(coordinate: startingPoint, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: endPoint, addressDictionary: nil)
        
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        
        direction.calculate{(response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print ("Error \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.carpoolMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.carpoolMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }

        
    }
    func addAnnotation(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.title = "test annotation"
        annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        carpoolMapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    

}
