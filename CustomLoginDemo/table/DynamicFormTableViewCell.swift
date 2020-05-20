//
//  DynamicFormTableViewCell.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit

class DynamicFormTableViewCell: UITableViewCell {
//    fileprivate var cellContentView: UIView?
    fileprivate var viewToRender: UIView?
    var horizontalPadding: CGFloat = 25
    var viewHash: String?
    fileprivate var mainContentView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func attachCellContent(_ view: UIView) {
        if mainContentView == nil {
            self.contentView.backgroundColor = UIColor.clear
            self.backgroundColor = UIColor.clear
            let mainView = UIView()
            self.addSubview(mainView)
            mainView.translatesAutoresizingMaskIntoConstraints = false
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            self.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0).isActive = true
            self.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
            self.mainContentView = mainView
        }
        viewToRender = view
    }
    
    func renderView() {
        if let contentView = mainContentView {
            if let view = viewToRender{
                viewToRender = nil
                contentView.subviews.forEach({ (view) in
                    view.removeFromSuperview()
                })
                
                contentView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding).isActive = true
                view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: horizontalPadding).isActive = true
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            }
        }
    }

}

