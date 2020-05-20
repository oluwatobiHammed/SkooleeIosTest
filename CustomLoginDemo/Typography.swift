//
//  Typography.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

public enum FontStyle: String {
    case Default = "Montserrat"
    case Bold = "Montserrat-Bold"
    case SemiBold = "Montserrat-SemiBold"
    case ExtraBold = "Montserrat-ExtraBold"
    case Black = "Montserrat-Black"
    case Medium = "Montserrat-Medium"
    case Light = "Montserrat-Light"
    case Icon = "fcmb-iconset"
    case CreditCardNumber = "OCRAStd"
    
    var size: CGFloat {
        switch self {
        case .Default:
            return 13
        case .Bold:
            return 13
        case .Icon:
            return 20
        default:
            return 13
        }
    }
    func step(by: CGFloat = 1)-> CGFloat {
        return self.size + (2.0 * by)
    }
    func getFont(sizeBy: CGFloat = 0)-> UIFont {
        return UIFont(name: self.rawValue, size: self.step(by: sizeBy))!
    }
    
    static func fontFromStyle(name: String)-> FontStyle? {
        switch name {
        case "Default":
            return FontStyle.Default
        case "Bold":
            return FontStyle.Bold
        case "SemiBold":
            return FontStyle.SemiBold
        case "ExtraBold":
            return FontStyle.ExtraBold
        case "Black":
            return FontStyle.Black
        case "Medium":
            return FontStyle.Medium
        case "Light":
            return FontStyle.Light
        case "Icon":
            return FontStyle.Icon
        case "CreditCardNumber":
            return FontStyle.CreditCardNumber
        default:
            return nil
        }
    }
}

enum FontIcon: UInt32 {
    case user = 0xe900
    case password_dotted = 0xe901
    case naira = 0xe902
    case calendar = 0xe903
    case caret_down = 0xe904
    case checked = 0xe905
    case close = 0xe906
    case fingerprint = 0xe907
    case gender = 0xe908
    case hand_burger = 0xe909
    case password = 0xe90a
    case phonebook = 0xe90b
    case pin = 0xe90c
    case comment = 0xe90d
    case access_time = 0xe90e
    case calendar_time = 0xe90f
    case sync = 0xe910
    case vertical_bars = 0xe911
    case cog = 0xe912
    case copy = 0xe913
    case phone = 0xe914
    case picture_placeholder = 0xe915
    case signature = 0xe916
    case certificate = 0xe917
    case location_pin = 0xe918
    case filedownload = 0xe919
    case information = 0xe91a
    case arrow_right = 0xe91b
    case card = 0xe91c
    case visa_logo = 0xe91d
    case add_rounded = 0xe91e
    case master_card = 0xe91f
    case search = 0xe920
    case user_fag = 0xe925
    case smiley_face = 0xe924
    case phone_wired = 0xe923
    case email = 0xe922
    case double_comment = 0xe921
    case star = 0xe926
    case comment_faq = 0xe950
    
    case cheque_service = 0xe927
//    case airtime = 0xe928
    case atm = 0xe929
    case card_pin = 0xe92a
    case card_two = 0xe92b
    case expense_tracker = 0xe92c
    case fx_transfer = 0xe92d
    case investment = 0xe92e
    case lifestyle = 0xe92f
    case limit = 0xe930
    case loans = 0xe931
    case pay_bills = 0xe932
    case plane = 0xe933
    case pos = 0xe934
    case qr_code = 0xe935
    case requests = 0xe936
    case savings = 0xe937
    case three_dot = 0xe938
    case trade = 0xe939
    case transfer = 0xe93a
    case www = 0xe93b
    case bell = 0xe93c
    case settings_cog = 0xe93d
    case ban = 0xe93e
    case eye = 0xe93f
    case flag = 0xe940
    case bin = 0xe941
    case share_platform = 0xe942
    case plus = 0xe943
    case wallet = 0xe944
    case facial_scan = 0xe946
    case paycode = 0xe947
    case import_export = 0xe948
    case dollar = 0xe949
    case location = 0xe94a
    case passport_data = 0xe94b
    case passport_visa = 0xe94c
    case time = 0xe94d
    case days = 0xe94e
    case world = 0xe94f
    case power = 0xe951
    case briefcase = 0xe952
    case support = 0xe953
    case telephone = 0xe954
    case link = 0xe955
    case bulk_transfer = 0xe958
    case caret_forward = 0xe959
    case caret_up = 0xe95a
    case show_text = 0xe95c
    case hide_text = 0xe95b
    
    case mail = 0xe945
    case info = 0xea0c
    
    case pounds = 0xe957
    case euro = 0xe956
    
    static func fromString(iconName: String)-> FontIcon? {
        switch iconName {
        case "user":
            return .user
        case "password":
            return .password
        case "mail":
            return .mail
        case "close":
            return .close
        case "fingerprint":
            return .fingerprint
        case "phonebook":
            return .phonebook
        case "password_dotted":
            return .password_dotted
        case "checked":
            return .checked
        case "pin":
            return .pin
        case "calendar":
            return .calendar
        case "gender":
            return .gender
        case "caret_down":
            return .caret_down
        case "hand_burger":
            return .hand_burger
        case "naira":
            return .naira
        case "comment":
            return .comment
        case "access_time":
            return .access_time
        case "calendar_time":
            return .calendar_time
        case "sync":
            return .sync
        case "vertical_bars":
            return .vertical_bars
        case "cog":
            return .cog
        case "copy":
            return .copy
        case "phone":
            return .phone
        case "picture_placeholder":
            return .picture_placeholder
        case "signature":
            return .signature
        case "certificate":
            return .certificate
        case "location_pin":
            return .location_pin
        case "filedownload":
            return .filedownload
        case "information":
            return .information
        case "arrow_right":
            return .arrow_right
        case "card":
            return .card
        case "visa_logo":
            return .visa_logo
        case "add_rounded":
            return .add_rounded
        case "master_card":
            return .master_card
        case "search":
            return .search
        case "user_fag":
            return .user_fag
        case "smiley_face":
            return .smiley_face
        case "phone_wired":
            return .phone_wired
        case "email":
            return .email
        case "double_comment":
            return .double_comment
        case "star":
            return .double_comment
        case "cheque_service":
            return .cheque_service
        case "airtime":
            return .telephone//.airtime
        case "atm":
            return .atm
        case "card_pin":
            return .card_pin
        case "card_two":
            return .card_two
        case "expense_tracker":
            return .expense_tracker
        case "fx_transfer":
            return .fx_transfer
        case "investment":
            return .investment
        case "lifestyle":
            return .lifestyle
        case "limit":
            return .limit
        case "loans":
            return .loans
        case "pay_bills":
            return .pay_bills
        case "plane":
            return .plane
        case "pos":
            return .pos
        case "qr_code":
            return .qr_code
        case "requests":
            return .requests
        case "savings":
            return .savings
        case "three_dot":
            return .three_dot
        case "trade":
            return .trade
        case "transfer":
            return .transfer
        case "www":
            return .www
        case "bell":
            return .bell
        case "settings_cog":
            return .settings_cog
        case "ban":
            return .ban
        case "eye":
            return .eye
        case "flag":
            return .flag
        case "bin":
            return .bin
        case "share_platform":
            return .share_platform
        case "plus":
            return .plus
        case "wallet":
            return .wallet
        case "facial_scan":
            return .facial_scan
        case "paycode":
            return .paycode
        case "import_export":
            return .import_export
        case "dollar":
            return .dollar
        case "location":
            return .location
        case "passport_data":
            return .passport_data
        case "passport_visa":
            return .passport_visa
        case "time":
            return .time
        case "days":
            return .days
        case "world":
            return .world
        case "comment_faq":
            return .comment_faq
        case "power":
            return .power
        case "briefcase":
            return .briefcase
        case "info":
            return .info
        case "support":
            return .support
        case "telephone":
            return .telephone
        case "link":
            return .link
        case "bulk_transfer":
            return .bulk_transfer
            
        case "pounds":
            return .pounds
        case "euro":
            return .euro
        case "caret_forward":
            return .caret_forward
        case "caret_up":
            return .caret_up
        case "show_text":
            return .show_text
        case "hide_text":
            return .hide_text
            
        default:
            return nil
        }
        
    }
    func font(_ size: CGFloat = FontStyle.Icon.size)-> UIFont? {
        if size == 0.0 {
            return nil
        }
//                ApplicationUtility.printFonts()
        let iconfont = FontStyle.Icon.rawValue
        return UIFont(name: iconfont, size: size)
    }
    
    func stringForIcon() -> String? {
        
        var rawIcon = self.rawValue;
        let xPtr = withUnsafeMutablePointer(to: &rawIcon, { $0 })
        return String(bytesNoCopy: xPtr, length:MemoryLayout<UInt32>.size, encoding: String.Encoding.utf32LittleEndian, freeWhenDone: false)
    }
    
    //loading font here ...
    func string(size: CGFloat = FontStyle.Icon.size, color: UIColor?) -> NSAttributedString? {
        var fontColor: UIColor? = color
        if (color == nil) {
            fontColor = ThemeManager.currentTheme().iconColor
        }
        if color == UIColor.clear {
            fontColor = nil
        }
        guard let font = self.font(size) , let string = self.stringForIcon() else { return nil }
        var attributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key : AnyObject]()
        
        attributes[NSAttributedString.Key.font] = font
        
        attributes[NSAttributedString.Key.foregroundColor] = fontColor
        
        // return attString
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    public func image(size: CGFloat = FontStyle.Icon.size, color: UIColor?) -> UIImage? {
        
        if size == 0.0 {
            return nil
        }
        
        guard let symbol = self.string(size: size, color: color) else { return nil }
        
        let mutableSymbol = NSMutableAttributedString(attributedString: symbol)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        mutableSymbol.addAttribute(NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue), value: paragraphStyle, range: NSMakeRange(0, mutableSymbol.length))
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        mutableSymbol.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
