//
//  UIStoryboard+Router.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//

import UIKit

extension UIStoryboard {
    /**
     переписать описание
     
     instantiate a UIViewController from the UIStoryboard.
     
     - parameter type: The type of UIViewController to instantiate.
     - parameter identifier: The identifier for the UIViewController (optional).
     
     By default, the class name of the UIViewController is used as the identifier.
     
     Example:
     ```
     class CustomViewController: UIViewController {}
     
     let storyboard = UIStoryboard()
     
     // registers the CustomViewController class with an identifier of "CustomViewController"
     let view = storyboard.instantiate(CustomViewController)
     ```
     */
    public func instantiate<T: UIViewController>(_ type: T.Type = T.self, withIdentifier identifier: String = String(describing: T.self)) -> T {
        guard let vc = instantiateViewController(withIdentifier: identifier) as? T else  {
            fatalError("Unknown view controller type (\(T.self)) for identifier: \(identifier)")
        }
        return vc
    }
}
