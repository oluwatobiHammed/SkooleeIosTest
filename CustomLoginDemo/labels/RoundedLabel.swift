//
//  RoundedLabel.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 3/1/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
class RoundedLabel: UILabel {
    
    @IBInspectable var circleColor: UIColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 0.33) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = circlePath()
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setFillColor(circleColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.closePath()
        ctx.fillPath()
        super.draw(rect)
    }
    
    
    fileprivate func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        circleFrame.origin.x = 0
        circleFrame.origin.y = 0
        return circleFrame
    }
    
    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
}
