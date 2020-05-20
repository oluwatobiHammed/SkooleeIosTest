//
//  BrandLabel.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 4/16/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
class BrandLabel: UILabel {
    
    @IBInspectable var verticalSpacing: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var horizontalSpacing: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var themeColor: String? {
        didSet {
            if let tColor = themeColor {
                self.textColor = ThemeManager.currentTheme().color(from: tColor)
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if verticalSpacing > 0  {
                contentSize.height += verticalSpacing + verticalSpacing
            }
            if horizontalSpacing > 0 {
                contentSize.width += horizontalSpacing + horizontalSpacing
            }
            return contentSize
        }
    }
    
    @IBInspectable var hexColor: String? {
        didSet {
            if let color = hexColor {
                self.textColor = UIColor.colorFromHexString(color)
            }
        }
    }
    
    @IBInspectable var sizeBy: CGFloat = 0 {
        didSet {
            updateLabelFont()
        }
    }
    
    @IBInspectable var themeFont: String = "Default" {
        didSet {
            updateLabelFont()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.updateLabelFont()
    }
    
    func updateLabelFont() {
        if let font = FontStyle.fontFromStyle(name: themeFont) {
            //self.usingFont(of: font, sizeBy: sizeBy)
        }
    }
    
//    override func drawText(in rect: CGRect) {
//        if verticalSpacing > 0 || horizontalSpacing > 0 {
//            let inset = UIEdgeInsets(top: verticalSpacing, left: horizontalSpacing, bottom: verticalSpacing, right: horizontalSpacing)
//            super.drawText(in: rect.inset(by: inset))
//        }
//        else {
//            super.drawText(in: rect)
//        }
//        //        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        //        super.drawText(in: rect.inset(by: insets))
//    }
    
}
