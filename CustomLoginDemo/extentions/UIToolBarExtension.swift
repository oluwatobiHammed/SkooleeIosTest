//
//  UIToolBarExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

extension UIToolbar {
    func customizeForInputAccessory(doneButton: UIBarButtonItem, titleItem: UIBarButtonItem? = nil, cancelButton: UIBarButtonItem? = nil) {
//        self.barTintColor = ThemeManager.currentTheme().mainColor.withAlphaComponent(0.6)
        cancelButton?.tintColor = ThemeManager.currentTheme().mainColor.withAlphaComponent(0.5)
        titleItem?.tintColor = ThemeManager.currentTheme().mainColor.withAlphaComponent(0.6)
        doneButton.tintColor = ThemeManager.currentTheme().mainColor
        var items: [UIBarButtonItem] = []
        if cancelButton != nil {
            items.append(cancelButton!)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        if titleItem != nil {
            items.append(titleItem!)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.append(doneButton)
        self.setItems(items, animated: true)
    }
}

