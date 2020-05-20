//
//  CaptionLabel.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 4/12/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import UIKit

//@IBDesignable
class CaptionLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.useCaptionFont()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()        
    }

}
