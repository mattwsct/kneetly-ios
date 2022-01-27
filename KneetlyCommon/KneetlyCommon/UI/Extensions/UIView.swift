//
//  UIView.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 30.11.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public enum RectSide {
    case left
    case right
    case bottom
    case top
    
    public static let allValues = [left, right, bottom, top]
    public static let sidesForPeek = [left, right]
}


extension UIView {
    func addConstraints(forViews views:[UIView], stackedHorizontallyWithPadding padding: CGFloat) {
        
        // Vertical constraints
        for view in views {
            self.snp.makeConstraints({ make in
                make.centerY.equalTo(view)
                make.top.lessThanOrEqualTo(view)
            })
        }
        
        // Left and right constraints
        views.first?.snp.makeConstraints({ make in
            make.left.equalToSuperview()
        })
        
        views.last?.snp.makeConstraints({ make in
            make.right.equalToSuperview()
        })
        
        // Padding
        for indx in stride(from: 0, to: views.count - 1, by: 1) {
            let leftView = views[indx]
            let rightView = views[indx + 1]
            
            leftView.snp.makeConstraints({ make in
                make.right.equalTo(rightView.snp.left).offset(-padding)
            })
        }
    }
}

extension UIView {
    public func shake(duration: CFTimeInterval = 0.5){
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.values = [ -10, 10, -5 ]
        animation.duration = duration / Double(animation.values!.count)
        self.layer.add(animation, forKey: "shake")
    }
}

extension UIView {
    public func alphaFromPoint(point: CGPoint) -> CGFloat {
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let alphaInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context!)
        let floatAlpha = CGFloat(pixel[3])
        return floatAlpha
    }
    
    public func pointNearPoint(point: CGPoint, offset: CGFloat ) -> Bool {
        return self.alphaFromPoint(point: point) >= offset
    }
}

@IBDesignable extension UIView {
    @IBInspectable public var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable public var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable public var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }

}


