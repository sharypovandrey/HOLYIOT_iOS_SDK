//
//  DeviceVC.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//

import UIKit

class DeviceVC: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var stateImageView: UIImageView!
    
    var device: HolyDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataLabel.text = device.debugDescription
        
        if device.state == .connected {
            stateImageView?.image = #imageLiteral(resourceName: "blue_on")
        } else {
            stateImageView?.image = #imageLiteral(resourceName: "blue_off")
        }
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
