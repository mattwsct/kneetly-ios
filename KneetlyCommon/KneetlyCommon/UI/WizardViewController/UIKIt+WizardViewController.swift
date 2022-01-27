//
//  UIKIt+WizardViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 02.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

public extension WizardPage where Self: UIViewController {
    var pageView: UIView { return self.view }
    var pageViewController: UIViewController? { return self }
}
