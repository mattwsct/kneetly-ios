//
//  DamagesView.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 19/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

public class DamagesView: UIImageView {
    
    private var damages: [Damage] = []
    public var onSelectDamage : (Damage)->Void = { _ in }
    public var onAddNewDamagePoint : (DamagePoint)->Void = { _ in }
    public var canAdd: Bool = true
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    public func update(damages: [Damage]) {
        
        self.removeAllDamages()
        self.damages = damages

        for damage in self.damages {
            if damage.damageType() == .exterior {
                damage.damagePoint = self.addNew(point: CGPoint(x: self.frame.size.width * CGFloat(damage.xcoordinate), y: self.frame.size.height * CGFloat(damage.ycoordinate)))
            }
        }
    }
    
    public func removeAllDamages() {
        for damage in self.damages {
            if damage.damageType() == .exterior {
                damage.damagePoint?.pointView.removeFromSuperview()
            }
        }
    }

    func handleTap(_ sender: UITapGestureRecognizer) {
        let point : CGPoint = sender.location(in: self)
        let touchInside = self.pointNearPoint(point: point, offset: 100)
        
        if (touchInside == true && canAdd == true) {
            self.onAddNewDamagePoint(self.addNew(point: point))
        }
    }
    
    func handleTapOnPoint(_ sender: UITapGestureRecognizer) {
        let view = sender.view
        let damage = self.damages.filter{ $0.damagePoint?.pointView == view}.first
        guard let selectedDamage = damage else {
            return
        }
        self.onSelectDamage(selectedDamage)
    }
    
    func addNew(point: CGPoint) -> DamagePoint {
        let pointView: UIView = self.newPointView(center: point)
        self.addSubview(pointView)
        let damagePoint : DamagePoint = DamagePoint(x: point.x/self.frame.size.width , y:point.y/self.frame.size.height , point: pointView)
        damagePoint.pointView = pointView
        return damagePoint
    }
    
    func newPointView(center: CGPoint) -> UIView {
        let pointView: UIView = UIView(frame: CGRect(origin: center, size: CGSize(width: 20.0, height: 20.0)))
        pointView.center = center
        pointView.backgroundColor = UIColor.red
        pointView.layer.cornerRadius = 10
        pointView.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTapOnPoint(_:)))
        pointView.addGestureRecognizer(tap)
        return pointView
    }
}
