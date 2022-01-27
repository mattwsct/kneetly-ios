//
//  MascotAnimatedViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 12/12/16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class MascotAnimatedViewController: UIViewController {

    @IBOutlet weak var viewForAnimation : UIView!

    var mascotView : MascotView = MascotView.init()
    
    public func performMascotAnimation() {
        guard viewForAnimation != nil else { return }
        mascotView.hideAndPeek(inView: viewForAnimation)
    }
}
