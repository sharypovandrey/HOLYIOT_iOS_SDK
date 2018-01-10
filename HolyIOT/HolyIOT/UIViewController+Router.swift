//
//  UIViewController+Router.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//

import UIKit

extension UIViewController {
    var router:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func showBlutoothPoweredOffStatusAlert(/*onDone: @escaping (UIAlertAction) -> Swift.Void*/){
        let alert = UIAlertController(title: "Holy error!", message: "Please turn bluetooth on", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "done", style: UIAlertActionStyle.default, handler: nil/*onDone*/))
        present(alert, animated: true, completion: nil)
    }
}
