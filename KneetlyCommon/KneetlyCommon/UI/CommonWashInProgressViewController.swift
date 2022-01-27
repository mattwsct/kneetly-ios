//
//  CommonWashInProgressViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 20/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation

open class CommonWashInProgressViewController: UIViewController {
    
    open var bookingId: String!
    
    @IBOutlet open weak var washInfoLabel: UILabel!
    @IBOutlet open weak var washDescriptionLabel: UILabel!
    
    // MARK: - View controller lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    open func configure(bookingId: String) {
        self.bookingId = bookingId
    }

}
