//
//  IconTextLabel.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 3/12/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import UIKit

//@IBDesignable
class IconTextLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var applyFormatting = true
    
    @IBInspectable var horizontalSpacing: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var verticalSpacing: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var labelText: String? {
        didSet {
            self.text = labelText
            self.updateUILabel()
        }
    }
    
    override var font: UIFont! {
        didSet {
            self.updateUILabel()
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            self.updateUILabel()
        }
    }
    
    @IBInspectable var iconSpacing: Int = 1 {
        didSet {
            self.updateUILabel()
        }
    }
    
    @IBInspectable var iconImage: UIImage? {
        didSet {
            self.updateUILabel()
        }
    }
    
    @IBInspectable var fontIcon: String? {
        didSet {
            if let str = fontIcon {
                if let icon = FontIcon.fromString(iconName: str) {
                    self.iconFont = icon
                }
            }
            self.updateUILabel()
        }
    }
    
    var iconFont: FontIcon? {
        didSet {
            self.updateUILabel()
        }
    }
    
    @IBInspectable var iconColor: UIColor = UIColor.black {
        didSet {
            self.updateUILabel()
        }
    }
    
    @IBInspectable var iconColorThemeName: String? {
        didSet {
            if let themeName = iconColorThemeName {
                if let color = ThemeManager.currentTheme().color(from: themeName) {
                    self.iconColor = color
                }
            }
        }
    }
    
    @IBInspectable var iconSize: CGFloat = 17.0 {
        didSet {
            self.updateUILabel()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += verticalSpacing + verticalSpacing
            contentSize.width += horizontalSpacing + horizontalSpacing
            return contentSize
        }
    }
    
    func updateUILabel() {
        if !applyFormatting {
            return
        }
        if let text = labelText {
            if let image = iconImage {
                self.drawIconText(withImage: image, text: text)
            }
            if let icon = iconFont {
                self.drawIconText(withIcon: icon, text: text)
            }
//            else if let iconFont = self.fontIcon {
//
//            }
        }
    }
    
     
//     override func drawText(in rect: CGRect) {
//         let insets = UIEdgeInsets(top: verticalSpacing, left: horizontalSpacing, bottom: verticalSpacing, right: horizontalSpacing)
//         super.drawText(in: rect.inset(by: insets))
//     }
    
    func drawIconText(withImage: UIImage, text: String) {
        
        let attributedString = NSMutableAttributedString(string: "")
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = withImage
        iconAttachment.bounds = CGRect(x: 0, y: 0, width: withImage.size.width, height: withImage.size.height)
        attributedString.append(NSAttributedString(attachment: iconAttachment))
        attributedString.append(buildAttributedText(forString: text))
        self.attributedText = attributedString
    }
    
    func drawIconText(withIcon: FontIcon, text: String) {
        let nsString = withIcon.string(size: iconSize, color: iconColor)!
        let attributedString = NSMutableAttributedString(attributedString: nsString)
        attributedString.append(buildAttributedText(forString: text))
        self.attributedText = attributedString
        
        self.setNeedsDisplay()
    }
    
    func buildAttributedText(forString: String)->NSAttributedString {
        var spacing = ""
        var index = 0
        while index < iconSpacing {
            spacing.append(" ")
            index += 1
        }
        let attributedString = NSMutableAttributedString(string: spacing + forString)
        let range = NSMakeRange(0, forString.count + iconSpacing )
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: self.font, range: range)        
        return attributedString
        
//        var attributes: [NSAttributedStringKey : AnyObject] = [NSAttributedStringKey : AnyObject]()
//        attributes[NSAttributedStringKey.font] = self.font
//        attributes[NSAttributedStringKey.foregroundColor] = textColor
//        return NSAttributedString(string: " " + forString, attributes: attributes)
//        return NSAttributedString(string: " " + forString)
    }

}
