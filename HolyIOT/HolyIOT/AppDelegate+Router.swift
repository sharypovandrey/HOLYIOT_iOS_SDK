//
//  AppDelegate+Router.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//
import UIKit

extension UIApplicationDelegate {
    
    var mainStoryboard:UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    /**
     Show device info
     
     - Parameters:
     - viewController: viewController
     - device: device
     */
    
    func showDeviceInfoInterface<C: UIViewController>(from viewController: C, device: HolyDevice) {
        let vc = mainStoryboard.instantiate(DeviceVC.self)
        vc.device = device
        viewController.show(vc, sender: nil)
    }
}

