//
//  UIColor+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 30.04.2018.
//

import UIKit

extension UIColor {
	
	/**
	Using arc4random provide random color
	
	- Returns: random color
	*/
	class var randomColor: UIColor {
		let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
		let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
		let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
		
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
	}
}

