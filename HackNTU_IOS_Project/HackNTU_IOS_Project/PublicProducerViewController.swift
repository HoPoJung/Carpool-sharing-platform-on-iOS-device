//
//  PublicProducerViewController.swift
//  HackNTU_IOS_Project
//
//  Created by Yuan-Pu Hsu on 21/12/2016.
//  Copyright © 2016 Peter. All rights reserved.
//

import UIKit

class PublicProducerViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var coinsEarnedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressStart(_ sender: Any) {
    }
    @IBAction func pressEnd(_ sender: Any) {
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
