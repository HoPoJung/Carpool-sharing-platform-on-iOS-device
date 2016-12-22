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


class CarpoolViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var carpoolMapView: MKMapView!
    
    @IBOutlet weak var StartingAddress: UITextField!
    @IBOutlet weak var DestinationAddress: UITextField!
    let manager = CLLocationManager()
    
    var myLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        carpoolMapView.userTrackingMode = .follow
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        carpoolMapView.delegate = self
        
        // Do any additional setup after loading the view.
    }

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
                print(address)
                self.StartingAddress.text = address
        }
    
        })
        
    }
    
    

}
