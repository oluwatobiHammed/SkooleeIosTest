//
//  LabelWithKeyboardGesture.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 6/7/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import UIKit

class LabelWithKeyboardGesture: BrandLabel, UIKeyInput, UITextInputTraits {
    
    var entry: [String] = []
    var labelInputView: UIView?
    var labelInputAccessoryView: UIView?
    
    var becameFirstResponder: EmptyCallback?
    var resignedFromFirstResponder: EmptyCallback?
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    var hasText: Bool {        
        return entry.count > 0
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return labelInputAccessoryView
        }
    }
    
    override var inputView: UIView? {
        get {
            return labelInputView
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
    
    func insertText(_ text: String) {
        entry.append(text)
    }
    
    func deleteBackward() {
        let _ = entry.popLast()
    }
    
    override func setup() {
        super.setup()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func onTap(_: AnyObject) {
        if isUserInteractionEnabled {
            let _ = self.becomeFirstResponder()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let val = super.becomeFirstResponder()
        self.becameFirstResponder?()
        return val
    }
    
    override func resignFirstResponder() -> Bool {
        let val = super.resignFirstResponder()
        self.resignedFromFirstResponder?()
        return val
    }
}
