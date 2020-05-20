//
//  Theme.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//


import Foundation
import UIKit
import Toast_Swift


let SelectedThemeKey = "SelectedTheme"

enum ColorSet: UInt32 {//5C2684
    case Background = 0xF8F8F8
    case Main = 0x5F138D
    case Accent = 0xFFB717
    case BorderColor = 0x979797
    case Danger = 0xEB5757
    case Success = 0x27AE60
    case Green = 0xA2DB38
    case Leaf = 0x87C700
    
    var asColor: UIColor {
        return UIColor.fromColorSet(colorSet: self)
    }
}

enum Theme: Int {
    case Default
    var mainColor: UIColor {
        switch self {
        case .Default:
            return ColorSet.Main.asColor
        }
    }
    
    var accentColor: UIColor {
        switch self {
        case .Default:
            return ColorSet.Accent.asColor
        }
    }
    
    var highlighColor: UIColor {
        switch self {
        case .Default:
           return ColorSet.Accent.asColor.withAlphaComponent(0.4)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default:
            //UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            return ColorSet.Background.asColor
        }
    }
    
    var iconColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .Default:
            let color = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 0.23)
            return color
        }
    }
    
    var dangerColor: UIColor? {
        switch self {
        case .Default:
            return UIColor.fromHEX(rgbValue: ColorSet.Danger.rawValue)
        }
    }
    
    //Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .Default:
            return .default
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .Default ? UIImage(named: "navBackground") : nil
    }
    
    func color(from: String)-> UIColor? {
        switch from {
        case "accent":
            return self.accentColor
        case "main":
            return self.mainColor
        case "background":
            return self.backgroundColor
        case "border":
            return self.borderColor
        case "danger":
            return self.dangerColor
        default:
            return nil
        }
    }
}

struct ThemeManager {
    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
            
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barStyle = theme.barStyle
        navBarAppearance.setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)
        
        var style = ToastStyle()
        style.backgroundColor = ThemeManager.currentTheme().accentColor
        style.messageColor = UIColor.black
        style.titleColor = ThemeManager.currentTheme().mainColor
        style.messageFont = FontStyle.Default.getFont()
        style.titleFont = FontStyle.SemiBold.getFont()
        ToastManager.shared.isTapToDismissEnabled = true
        // toggle queueing behavior
        ToastManager.shared.isQueueEnabled = true
        ToastManager.shared.style = style
        
        
    }
    
    static func defaultFont(sizeBy: CGFloat = 0)-> UIFont {
        return FontStyle.Default.getFont(sizeBy: sizeBy)
    }
    
    static func withFont(using: FontStyle, sizeBy: CGFloat = 0)-> UIFont {
        return using.getFont(sizeBy: sizeBy)
    }
    
    static func captionFont(sizeBy: CGFloat = 4)-> UIFont {
        return FontStyle.Bold.getFont(sizeBy: sizeBy)
    }
}
