//
//  PostCollectionViewCell.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: CaptionLabel!
    @IBOutlet weak var bodyLabel: BrandLabel!
    
    var data: Post? {
        didSet{
            if let data = data {
                titleLabel.text = data.title
                bodyLabel.text = data.body
            }
        }
        
    }
}
