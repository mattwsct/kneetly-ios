//
//  BigButton.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 29.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

public class KneetlyButton: UIButton {
    
    override public var tintColor: UIColor! {
        didSet {
            loadView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    @IBInspectable public var fontSize: CGFloat = 24.0 {
        didSet {
            loadView()
        }
    }
    
    @IBInspectable public var horizontalInsets: CGFloat = 35 {
        didSet {
            loadView()
        }
    }
    
    private func loadView() {
        self.layer.cornerRadius = cornerRadius > 0 ? cornerRadius : 16.5
        self.layer.borderWidth = borderWidth > 0 ? borderWidth : 1.0
        self.layer.borderColor = self.tintColor.cgColor
        self.setTitleColor(self.tintColor, for: .normal)
        self.setTitleColor(R.color.kneetly.textGray(), for: .disabled)
        self.titleLabel?.font = UIFont.kneetly.buttonFontOfSize(fontSize)
        self.contentEdgeInsets = UIEdgeInsetsMake(10.0, horizontalInsets, 10.0, horizontalInsets)
    }
    
    func setEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.alpha = isEnabled ? 1.0 : 0.4
        self.layer.borderColor = isEnabled ? self.tintColor.cgColor : R.color.kneetly.textGray().cgColor
    }
}
