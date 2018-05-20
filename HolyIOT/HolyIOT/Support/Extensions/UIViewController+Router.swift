//
//  UIViewController+Router.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//

import UIKit

extension UIViewController {
	
	typealias EmptyBlock = () -> ()
	
    var router:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
	
	/**
	Show Blutooth powered off Status warning
	
	on Done action trying to open Settings page to allow user to turn bluetooth on
	*/
    func showBlutoothPoweredOffStatusAlert(){
        let alert = UIAlertController(title: "holy_error".localized, message: "turn_bluetooth_on".localized, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "done".localized, style: .default) { action in
			let url = URL(string: "App-Prefs:root=General")
			UIApplication.shared.openURL(url!)
			})
        present(alert, animated: true, completion: nil)
    }
	
	/**
	Swow stop updating process warning
	
	- Parameters:
	- onAbort: EmptyBlock complition on user selected abort
	- onCancel: EmptyBlock complition on user selected cancel
	*/
	func showStopProcessWarning(_ onAbort: @escaping EmptyBlock, _ onCancel: @escaping EmptyBlock) {
		let alertView = UIAlertController(title: "warning".localized, message: "ask_stop_process".localized, preferredStyle: .alert)
		alertView.addAction(UIAlertAction(title: "abort".localized, style: .destructive) {
			(action) in
			onAbort()
		})
		alertView.addAction(UIAlertAction(title: "cancel".localized, style: .cancel) {
			(action) in
			onCancel()
		})
		present(alertView, animated: true)
	}
}
