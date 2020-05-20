//
//  UIResponder.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    
    fileprivate weak static var _currentFirstResponder: UIResponder? = nil
    
    static var currentFirstResponder: UIResponder? {
        get {
            UIResponder._currentFirstResponder = nil
            UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
            return UIResponder._currentFirstResponder
        }
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}

