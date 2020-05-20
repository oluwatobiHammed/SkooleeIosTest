//
//  ActivityIndicatorExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//


import Foundation
import UIKit

extension UIActivityIndicatorView {
    func customizeToTheme() {
        self.color = ThemeManager.currentTheme().mainColor
    }
    func customizeToAccentTheme() {
        self.color = ThemeManager.currentTheme().accentColor
    }
}
