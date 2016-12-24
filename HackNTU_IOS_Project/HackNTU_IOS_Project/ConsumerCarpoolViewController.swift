//
//  ConsumerCarpoolViewController.swift
//  HackNTU_IOS_Project
//
//  Created by Yuan-Pu Hsu on 23/12/2016.
//  Copyright © 2016 Peter. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ConsumerCarpoolViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var searchForPairingView: UIView!
    @IBOutlet weak var consumerMapView: MKMapView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var startPositionTextField: UITextField!
    @IBOutlet weak var destinationPositionTextField: UITextField!
    @IBOutlet weak var timeIntervalPicker: UIPickerView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    let pickerArray = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    let startLocationManager = CLLocationManager()
    var userLocations: [CLLocation] = []
    var destinationCoord: CLLocationCoordinate2D?
    var startCoord: CLLocationCoordinate2D?
    var timer = Timer()
    var leftTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationManager.requestWhenInUseAuthorization()
        consumerMapView.userTrackingMode = .follow
        startLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        startLocationManager.startUpdatingLocation()
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .medium
        self.currentTimeLabel.text = dateFormat.string(from: date)
        self.timeLeftLabel.text = "5"
        
        moveViewForLoading(up: false)
        
        startLocationManager.delegate = self
        consumerMapView.delegate = self
        self.destinationPositionTextField.delegate = self
        self.timeIntervalPicker.delegate = self
        self.timeIntervalPicker.dataSource = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.destinationPositionTextField.resignFirstResponder()
        checkDestinationAndLocate()
        return true
    }
    
    func checkDestinationAndLocate() {
        self.destinationPositionTextField.text = "20730 Valley Green Dr Cupertino, CA 95014 United States"
//        self.destinationPositionTextField.text = "台北市大安區羅斯福路四段一號"
        let address = self.destinationPositionTextField.text!
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    self.destinationCoord = location!.coordinate
                    self.consumerMapView.addAnnotation(MKPlacemark(placemark: placemark))
                }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            let location = locations.last! as CLLocation
            let goecoder = CLGeocoder()
            goecoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, e) -> Void in
                    if e != nil{
                        print("Error: " + (e?.localizedDescription)!)
                    }
                    else{
                        let placemark = (placemarks?.last)! as CLPlacemark
                        let address: String = "\(placemark.name!) \(placemark.country!) \(placemark.administrativeArea!) \(placemark.subAdministrativeArea!) \(placemark.locality!)"
                        print(address)
                        self.startCoord = location.coordinate
                        self.startPositionTextField.text = address
                    }
                })
        }
    }
    @IBAction func navigateAndMatchBtn(_ sender: Any) {
        if (self.startCoord != nil && self.destinationCoord != nil) {
            let sourcePlacemark = MKPlacemark(coordinate: self.startCoord!)
            let destinationPlacemark = MKPlacemark(coordinate: self.destinationCoord!)
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            let sourceAnnotation = MKPointAnnotation()
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            let destinationAnnotation = MKPointAnnotation()
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            let directions = MKDirections(request: directionRequest)
            directions.calculate {
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    
                    return
                }
                
                let route = response.routes[0]
                self.consumerMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.consumerMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
            moveViewForLoading(up: true)
        }
    }
    
    @IBAction func pressCancel(_ sender: Any) {
        self.performSegue(withIdentifier: "BackToMain", sender: self)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func moveViewForKeyboard(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func moveViewForLoading(up: Bool) {
        let moveDuration = 0.3
        let moveDistance = self.searchForPairingView.bounds.maxY
        let movement: CGFloat = up ? -moveDistance : moveDistance
        
        UIView.beginAnimations("animateLoadingView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.searchForPairingView.frame = self.searchForPairingView.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        if up {
            self.leftTime = Int(self.timeLeftLabel.text!)! * 60
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ConsumerCarpoolViewController.countDown), userInfo: nil, repeats: true)
        }
    }
    
    func countDown() {
        if self.leftTime >= 0 {
            let minute = self.leftTime / 60
            let second = self.leftTime % 60
            self.timeLeftLabel.text = "\(minute):\(second)"
            self.leftTime -= 1
            return
        }
        self.timer.invalidate()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveViewForKeyboard(textField: textField, moveDistance: -250, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveViewForKeyboard(textField: textField, moveDistance: -250, up: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.timeLeftLabel.text = String(pickerArray[row])
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

}
