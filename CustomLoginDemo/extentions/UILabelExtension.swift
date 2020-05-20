//
//  UILabelExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    var stringResource: StringResource? {
        get {
            return nil
        }
        set (value) {
            if let value = value {
                self.localizeUsing(key: value.rawValue)
            }
            else {
                self.text = ""
            }
        }
    }
    func localizeUsing(key: String) {
        self.text = localizedString(forKey: key)
    }
    func useCaptionFont() {
        self.font = ThemeManager.captionFont()
    }
    func useCaptionFont(by: CGFloat) {
        self.font = ThemeManager.captionFont(sizeBy: by)
    }
    func useDefaultFont(by: CGFloat=0) {
        self.font = ThemeManager.defaultFont(sizeBy: by)
    }
    func usingFont(of: FontStyle, sizeBy: CGFloat = 0) {
        self.font = of.getFont(sizeBy: sizeBy)
    }
    func usingIcon(icon: FontIcon, size: CGFloat = FontStyle.Icon.size, color: UIColor? = nil) {
        self.attributedText = icon.string(size: size, color: color)
    }
    
    func roundCorner(backgroundColor: UIColor, cornerRadius:CGFloat = 20){
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = backgroundColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
    func formatForFormFieldLabel() {
        self.useDefaultFont(by: 0.3)
        self.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 0.76)
    }
    
    func computeEstimatedSize()-> CGRect {
        self.lineBreakMode = .byWordWrapping
        self.sizeToFit()
        return self.frame
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) ->UIColor {
         return  UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainBlue() ->UIColor {
        return  UIColor.rgb(red: 0, green: 150, blue:255)
    }
}
