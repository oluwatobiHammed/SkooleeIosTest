//
//  UIViewExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var getSafeTopAnchor: NSLayoutYAxisAnchor {
        get {
            if #available(iOS 11.0, *) {
                let safeGuide = self.safeAreaLayoutGuide
                return safeGuide.topAnchor
            } else {
                return self.topAnchor
            }
        }
    }
    var getSafeBottomAnchor: NSLayoutYAxisAnchor {
        get {
            if #available(iOS 11.0, *) {
                let safeGuide = self.safeAreaLayoutGuide
                return safeGuide.bottomAnchor
            } else {
                return self.bottomAnchor
            }
        }
    }
    var getSafeTrailingAnchor: NSLayoutXAxisAnchor {
        get {
            if #available(iOS 11.0, *) {
                let safeGuide = self.safeAreaLayoutGuide
                return safeGuide.trailingAnchor
            } else {
                return self.trailingAnchor
            }
        }
    }
    var getSafeLeadingAnchor: NSLayoutXAxisAnchor {
        get {
            if #available(iOS 11.0, *) {
                let safeGuide = self.safeAreaLayoutGuide
                return safeGuide.leadingAnchor
            } else {
                return self.leadingAnchor
            }
        }
    }
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
//    func asImage()-> UIImage? {
//        if #available(iOS 10.0, *) {
////            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
////            return renderer.image(actions: { (rendererContext) in
////                self.layer.render(in: rendererContext.cgContext)
////            })
//            let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
//            let image = renderer.image { ctx in
//                self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
//            }
//            return image
//        } else {
//            // Fallback on earlier versions
//            return UIImageView(view: self).image
//        }
//
//    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addDefaultBrandBorder(width: CGFloat = 1.0) {
        layer.borderColor = ThemeManager.currentTheme().borderColor.cgColor
        layer.borderWidth = width
    }
    
    func rotateTo(angle: CGFloat, duration: TimeInterval = 0.4, completion: EmptyCallback? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(rotationAngle: angle)
        }) { (completed) in
            completion?()
        }
    }
    
    func makeCircular(radius: CGFloat? = nil) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.clipsToBounds = true
    }
    
//    func shake(duration: CFTimeInterval) {
//        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
//        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
//        
//        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
//        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
//            ( degrees: Double) -> Double in
//            let radians: Double = (Double.pi * degrees) / 180.0
//            return radians
//        }
//        
//        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
//        shakeGroup.animations = [translation, rotation]
//        shakeGroup.duration = duration
//        
//        self.layer.add(shakeGroup, forKey: "shakeIt")
//    }
    
    /// Removes specified set of constraints from the views in the receiver's subtree and from the receiver itself.
    ///
    /// - parameter constraints: A set of constraints that need to be removed.
    func removeConstraintsFromSubtree(_ constraints: Set<NSLayoutConstraint>) {
        var constraintsToRemove = [NSLayoutConstraint]()
        
        for constraint in self.constraints {
            if constraints.contains(constraint) {
                constraintsToRemove.append(constraint)
            }
        }
        
        self.removeConstraints(constraintsToRemove)
        
        for view in self.subviews {
            view.removeConstraintsFromSubtree(constraints)
        }
    }
    
    var hashCode: String {
        get {
            return String(UInt(bitPattern: ObjectIdentifier(self)))
        }
    }
}
