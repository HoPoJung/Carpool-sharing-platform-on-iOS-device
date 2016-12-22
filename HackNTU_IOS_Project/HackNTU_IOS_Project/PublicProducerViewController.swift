//
//  PublicProducerViewController.swift
//  HackNTU_IOS_Project
//
//  Created by Yuan-Pu Hsu on 21/12/2016.
//  Copyright © 2016 Peter. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PublicProducerViewController: UIViewController {

    @IBOutlet var trackerMapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var coinsEarnedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var userLocation:[CLLocation] = []
    var tracedDistance:[CLLocationDistance] = []
    var lastTracedIndex: Int = 0
    var lastTracedDistance: Float = 0.0
    let manager = CLLocationManager()
    var cumulativeDistance: Float = 0.0
    var cumulativeCoins: Float = 0
    var timer = Timer()
    var counterSecond: Int = 0
    var counterMinute: Int = 0
    var counterHour: Int = 0
    
    func checkAuthorityOfMap() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Ready for Tracking")
//        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        trackerMapView.userTrackingMode = .follow
        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.distanceFilter = 10
        manager.delegate = self
        trackerMapView.delegate = self
        distanceLabel.text = "0.0"
        durationLabel.text = "0:00"
        coinsEarnedLabel.text = "0.00"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressStart(_ sender: Any) {
        manager.startUpdatingLocation()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PublicProducerViewController.changeTime), userInfo: nil, repeats: true)
        print("Start tracking...")
    }
    @IBAction func pressEnd(_ sender: Any) {
        manager.stopUpdatingLocation()
        timer.invalidate()
        print("Tracking stopped.")
    }
    
    func changeTime() {
        counterSecond += 1
        if counterSecond >= 60 {
            counterMinute += 1
            counterSecond -= 60
        }
        if counterMinute >= 60 {
            counterHour += 1
            counterMinute -= 60
        }
        if counterHour == 0 && counterMinute == 0 {
            durationLabel.text = "\(counterSecond)"
            return
        }
        if counterHour == 0 && counterMinute > 0 && counterSecond < 10 {
            durationLabel.text = "\(counterMinute):0\(counterSecond)"
            return
        }
        else if counterHour == 0 {
            durationLabel.text = "\(counterMinute):\(counterSecond)"
            return
        }
        if counterHour > 0 && counterMinute >= 10 && counterSecond < 10 {
            durationLabel.text = "\(counterHour):\(counterMinute):0\(counterSecond)"
            return
        }
        if counterHour > 0 && counterMinute < 10 && counterSecond >= 10 {
            durationLabel.text = "\(counterHour):0\(counterMinute):\(counterSecond)"
            return
        }
        if counterHour > 0 && counterMinute < 10 && counterSecond < 10 {
            durationLabel.text = "\(counterHour):0\(counterMinute):0\(counterSecond)"
            return
        }
        durationLabel.text = "\(counterHour):\(counterMinute):\(counterSecond)"
        return
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

extension PublicProducerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last!)
        userLocation.append(locations.last!)
        
        if userLocation.count > 1 {
            let startIndex = userLocation.count - 1
            let endIndex = userLocation.count - 2
            let area = [userLocation[startIndex].coordinate, userLocation[endIndex].coordinate]
            let polyLine = MKPolyline(coordinates: area, count: area.count)
            trackerMapView.add(polyLine)
            tracedDistance.append(userLocation[startIndex].distance(from: userLocation[endIndex]))
        }
    }
}

extension PublicProducerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.lineWidth = 5
        let nowSpeed = userLocation.last!.speed

//        if tracedDistance.last != nil {
//            for dis in tracedDistance {
//                cumulativeDistance += Float(dis)
//            }
//            tracedDistance.removeLast(1)
//        }
        if tracedDistance.last != nil {
            cumulativeDistance += Float(tracedDistance.last!)
        }
        // Calculate how many coins earned
        if (lastTracedDistance < cumulativeDistance - 500) && (lastTracedIndex < userLocation.count - 10) {
            let deltaDistance = Float(cumulativeDistance - lastTracedDistance)
            let deltaTime = Float(userLocation.last!.timestamp.timeIntervalSince(userLocation[lastTracedIndex].timestamp))
            let avgSpeed = deltaDistance/deltaTime
            cumulativeCoins += 100 / avgSpeed
            coinsEarnedLabel.text = "\(cumulativeCoins)"
            lastTracedIndex = userLocation.count
            lastTracedDistance = cumulativeDistance
        }
        
        
        if nowSpeed < 20 {
            polylineRenderer.strokeColor = .green
        }
        else {
            polylineRenderer.strokeColor = .red
        }
        distanceLabel.text = String(format: "%3.2f", cumulativeDistance/1000)
        
        return polylineRenderer
    }
}


