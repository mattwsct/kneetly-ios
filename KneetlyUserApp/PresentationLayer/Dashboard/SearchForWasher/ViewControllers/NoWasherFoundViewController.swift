//
//  NoWasherFoundViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 14/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class NoWasherFoundViewController: WasherSearchResultViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

