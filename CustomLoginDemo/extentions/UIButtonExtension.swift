//
//  UIButtonExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func customizeToTheme(veritcalSpace: CGFloat = 18) {
        self.layer.cornerRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: veritcalSpace, left: 10, bottom: veritcalSpace, right: 10)
        
        self.backgroundColor = ThemeManager.currentTheme().mainColor
        self.tintColor = UIColor.white
        //self.titleLabel?.usingFont(of: FontStyle.Default)
        
    }
    
    func roundEdges(borderColor: UIColor = ThemeManager.currentTheme().mainColor, radius: CGFloat = 15, borderWidth: CGFloat = 2) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }
    
    func customizeToThemeStyleOne() {
        self.layer.cornerRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        
        self.backgroundColor = UIColor.fromHEX(rgbValue: 0xf2f2f2)//UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.18)
        self.tintColor = ThemeManager.currentTheme().mainColor
        //self.titleLabel?.usingFont(of: FontStyle.Default)
    }
    
    func customizeToThemeStyleTwo() {
        self.layer.cornerRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        
        self.backgroundColor = UIColor(red: 0.37, green: 0.07, blue: 0.55, alpha: 0.18)
        self.tintColor = ThemeManager.currentTheme().mainColor
        //self.titleLabel?.usingFont(of: FontStyle.Default)
    }
    
    func customizeToThemeStyleThree() {
        self.layer.cornerRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        
        self.backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 0.17)
        self.tintColor = UIColor.colorFromHexString("#EB5757")
        //self.titleLabel?.usingFont(of: FontStyle.Default)
    }
    
    func customizeToThemeStyleFour() {
        self.layer.cornerRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.backgroundColor = UIColor.clear
        self.tintColor = ThemeManager.currentTheme().mainColor
        self.layer.borderColor = ThemeManager.currentTheme().mainColor.cgColor
        self.layer.borderWidth = 1
        //self.titleLabel?.usingFont(of: FontStyle.Default)
    }
}
