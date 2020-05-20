//
//  PinEntryPoint.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 3/12/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import UIKit

class PinEntryPoint: UILabel {
    var selected: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = circlePath()
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        if selected {
            ctx.setFillColor(ThemeManager.currentTheme().mainColor.cgColor)
        }
        else {
            ctx.setFillColor(UIColor.lightGray.cgColor)
        }
        ctx.addPath(path.cgPath)
        ctx.closePath()
        ctx.fillPath()
    }
    
    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    fileprivate func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
        circleFrame.origin.x = 0
        circleFrame.origin.y = 0
        return circleFrame
    }
}
