//
//  StringExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//


import Foundation
import UIKit

extension String: RadioListDataItem {
    
    func getItemLabel() -> String {
        return self
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func hasSpecialCharacters()-> Bool {
        if let _ = self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) {
            return true
        }
        return false
    }
    
    func padAsNigeriaPhoneNumber()-> String {
        if self.count < 14 && self.contains("+") == false{
            var count = 0
            var append: [String] = []
            self.reversed().forEach { (character) in
                if count < 10 {
                    append.append(String(character))
                }
                count += 1
            }
            return "+234"+append.reversed().joined()
            
        }
        return self
    }
    
    func base64ConvertToImage()-> UIImage? {
        if (self.isEmpty) {
            return nil
        }else {
            // !!! Separation part is optional, depends on your Base64String !!!
            let temp = self.components(separatedBy: ",")
            if temp.count > 1 {
                if let dataDecoded : Data = Data(base64Encoded: temp[1], options: .ignoreUnknownCharacters){
                    return UIImage(data: dataDecoded)
                }
            }
        }
        return nil
    }
    
    func emojiToImage(background: UIColor = UIColor.white) -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        background.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self.characters)
        stride(from: 0, to: characters.count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, characters.count)]))
        }
        return result
    }
    
    func isValidEmail()-> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
//        return self.range(of: "\\d", options: .regularExpression) != nil
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width;
    }
    
    
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        //self.map { String($0) }
        let characters = Array(self.characters)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
    
    func truncate(length: Int, trailing: String = "...") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    func highlight(searchTerm: String, ellipseColor: UIColor? = nil, backgroundColor: UIColor? = ThemeManager.currentTheme().highlighColor, foregroundColor: UIColor? = nil)->NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: self)
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
            let range = NSRange(location: 0, length: self.utf16.count)
            var foundCount = 0
            for match in regex.matches(in: self, options: .withTransparentBounds, range: range) {
                foundCount += 1
                if let color = backgroundColor {
                    attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: match.range)
                }
                if let color = foregroundColor {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: match.range)
                }
            }
            if foundCount == 0 && ellipseColor != nil {
                attributedString.append("...".addHighlightEllipse(foregroundColor: ellipseColor!))
            }
            return attributedString
        } catch _ {
//            NSLog("Error creating regular expresion")
            return nil
        }
    }
    
    func addHighlightEllipse(foregroundColor: UIColor? = ThemeManager.currentTheme().highlighColor)->NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: " "+self)
        let range = NSMakeRange(0, self.count + 1)
        if let color = foregroundColor {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        //attributedString.addAttribute(NSAttributedString.Key.font, value: FontStyle.Bold.getFont(sizeBy: 1), range: range)
        return attributedString
    }
    
    func appendRandomString(length: Int = 10, numbersOnly: Bool = false)->String {
        var chars = "abcdefghijklmnopqrstuvwxyz"
        if numbersOnly {
            chars = "0123456789"
        }
        var value = self.appending("")
        
        for _ in 1...length {
            let indexOffset = arc4random_uniform(UInt32(chars.count))
            let char = chars.index(chars.startIndex, offsetBy: Int(exactly: indexOffset)!)
            value = value.appending(String(describing: chars[char]))
        }
        return value
    }
    
    mutating func removingRegexMatches(pattern: String, replaceWith: String = "") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return
        }
    }
    
    
}



