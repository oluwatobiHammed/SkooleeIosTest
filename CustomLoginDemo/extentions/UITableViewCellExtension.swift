//
//  UITableViewCellExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//
import Foundation
import UIKit

extension UITableViewCell {
    func createCellRadioButton()-> RadioButton {
        let label = BrandLabel()
        label.text = nil
        label.tag = 2000
        let radioButton = RadioButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.addSubview(radioButton)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        
        radioButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -45).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        return radioButton
    }
    
    func createLockedImageViewIndicator()-> UIImageView {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "lock_off"))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return imageView
    }
}
