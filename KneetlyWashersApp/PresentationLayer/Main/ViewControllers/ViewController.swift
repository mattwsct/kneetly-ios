//
//  ViewController.swift
//  KneetlyWashers
//
//  Created by Matt Westcott on 22/8/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
    }
    
    @IBAction func forgotLoginPressed(_ sender: UIButton) {
        if let url = NSURL(string: "https://kneetlyweb.beitsafe.technology/") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    @IBAction func registerPressed(_ sender: AnyObject) {
        if let url = NSURL(string: "https://kneetlyweb.beitsafe.technology/") {
            UIApplication.shared.openURL(url as URL)
        }
    }

}

