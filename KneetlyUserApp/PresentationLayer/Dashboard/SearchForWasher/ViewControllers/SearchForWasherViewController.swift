//
//  SearchForWasherViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 30/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class SearchForWasherViewController: UIViewController, WashCancellation {

    var bookingId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //showWasherFoundAfterDelay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        super.viewWillAppear(animated)
    }
    
    private func showWasherFoundAfterDelay() {
        let deadlineTime = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.performSegue(withIdentifier: R.segue.searchForWasherViewController.toWasherFound, sender: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancelWash(forBookingId: bookingId)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? WasherFoundViewController {
            dst.bookingId = bookingId
        }
    }
}
