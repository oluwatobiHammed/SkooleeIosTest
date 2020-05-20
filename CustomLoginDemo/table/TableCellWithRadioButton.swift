//
//  TableCellWithRadioButton.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class TableCellWithRadioButton: UITableViewCell {
    var radioButton: RadioButton?
    var lockedImage: UIImageView?
    
    var lockCell: Bool = false {
        didSet {
            if lockCell {
                self.radioButton?.isHidden = true
                self.lockedImage?.isHidden = false
            }
            else {
                self.radioButton?.isHidden = false
                self.lockedImage?.isHidden = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    override func prepareForReuse() {
        self.lockCell = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        let bgView = self.selectedBackgroundView
        if selected {
            self.radioButton?.isSelected = true
        }
        else {
            self.radioButton?.isSelected = false
        }
    }
    
    func setup() {
        radioButton = createCellRadioButton()
        lockedImage = createLockedImageViewIndicator()
        lockedImage?.isHidden = true
        //        let bgView = self.selectedBackgroundView
        radioButton?.isUserInteractionEnabled = false
        self.selectionStyle = .none
        self.selectedBackgroundView = UIView()
    }
    
    func hideRadioButton(hide: Bool = true) {
        self.radioButton?.isHidden = hide
    }
}
