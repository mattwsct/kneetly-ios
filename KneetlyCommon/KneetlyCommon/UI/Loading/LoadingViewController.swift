//
//  LoadingViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 12/23/16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import SnapKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = R.color.kneetly.lightGray()
        //TODO: Add activity indicator
        
        let brushImage = UIImageView.init(image: UIImage.init(named: "whiteBrush"))
        let logoImage = UIImageView.init(image: UIImage.init(named: "kneetlyLogoLarge"))
        
        self.view.addSubview(brushImage)
        self.view.addSubview(logoImage)
        
        brushImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }

 
}
