//
//  MascotView.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 09/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public class MascotView : UIImageView {
    
    var mascot: Mascot
    private var animationCompleted: Bool = true
    private static let animationDuration: TimeInterval = 0.2
    
    public init(mascot : Mascot) {
        self.mascot = mascot
        super.init(image: mascot.image())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.mascot = Mascot()
        super.init(coder: aDecoder)
    }
    
    public init() {
        let rectSide = RectSide.sidesForPeek.randomElement()
        self.mascot = Mascot(rectSide: rectSide)
        super.init(image: mascot.image())
    }
    
    func setMascot(mascot: Mascot) {
        self.mascot = mascot
        self.image = self.mascot.image()
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (self.image?.size.width)!, height: (self.image?.size.height)!)
        self.transform = CGAffineTransform.identity
    }
    
    public func hideAndPeek(inView view: UIView) {
        self.hide { 
            self.peek(inView: view)
        }
    }
    
    public func peek(inView view: UIView) {
        if self.animationCompleted == false {
            return
        }
        
        self.animationCompleted = false
        let rectSide = RectSide.sidesForPeek.randomElement()
        self.setMascot(mascot: Mascot(rectSide: rectSide))
        self.peek(fromSide: rectSide, inView: view)
    }
    
    private func peek(fromSide side: RectSide, inView view: UIView) {
        let distance = self.frame.height/3.0
        
        var rotation : CGFloat!
        var fromPoint : CGPoint!
        var translationX : CGFloat!
        var translationY : CGFloat!
        
        switch side {
        case .left:
            fromPoint = CGPoint(x: -self.frame.size.width, y: CGFloat.random(min: self.frame.size.height/2.0, max:view.frame.size.height - self.frame.size.height))
            translationY = CGFloat.random(min: 0, max: -distance)
            translationX = self.frame.size.width
            rotation = CGFloat.random(min: CGFloat(M_PI/12.0), max: CGFloat(M_PI/6.0))
        case .right:
            fromPoint = CGPoint(x: view.frame.size.width, y: CGFloat.random(min: self.frame.size.height/2.0, max:view.frame.size.height - self.frame.size.height))
            translationY = CGFloat.random(min: 0, max: -distance)
            translationX = -self.frame.size.width
            rotation = CGFloat.random(min: -CGFloat(M_PI/12.0), max: -CGFloat(M_PI/6.0))
        case .top:
            fromPoint = CGPoint(x: CGFloat.random(min: self.frame.size.width/2.0, max:view.frame.size.width - self.frame.size.width/2.0), y: -self.frame.size.height)
            translationY = self.frame.size.width
            translationX = CGFloat.random(min: -distance, max: distance)
            rotation = CGFloat.random(min: -CGFloat(M_PI/3.0), max: CGFloat(M_PI/3.0))
        case .bottom:
            fromPoint = CGPoint(x: CGFloat.random(min: self.frame.size.width/2.0, max:view.frame.size.width - self.frame.size.width/2.0), y: self.frame.size.height)
            translationY = -self.frame.size.width
            translationX = CGFloat.random(min: -distance, max: distance)
            rotation = CGFloat.random(min: -CGFloat(M_PI * 6.0), max: CGFloat(M_PI * 6.0))
        }
        
        var fromFrame = self.frame
        fromFrame.origin = fromPoint
        self.frame = fromFrame
        view.addSubview(self)
        
        UIView.animate(withDuration: MascotView.animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            var peekTransform = CGAffineTransform(translationX: translationX, y: translationY)
            peekTransform = peekTransform.rotated(by: rotation)
            self.transform = peekTransform
        }, completion:{ _ in
            self.animationCompleted = true
        })
    }
    
    public func hide(completion: @escaping () -> Void) {
        self.animationCompleted = false
        
        UIView.animate(withDuration: MascotView.animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform.identity
        }, completion:{ _ in
            self.animationCompleted = true
            completion()
        })
    }
    
    
}
