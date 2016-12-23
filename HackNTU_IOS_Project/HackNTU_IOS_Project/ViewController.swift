//
//  ViewController.swift
//  HackNTU_IOS_Project
//
//  Created by 何柏融 on 2016/11/23.
//  Copyright © 2016年 Peter. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logoView: logoView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logoView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        navigationItem.title = Shared.shared.userName
        coinsLabel.text = String(format: "%4.2f", Shared.shared.coin)
        distanceLabel.text = String(format: "%3.2f", Shared.shared.distance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

