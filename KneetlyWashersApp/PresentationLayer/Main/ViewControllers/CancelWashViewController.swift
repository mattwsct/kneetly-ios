//
//  CancelWashViewController.swift
//  KneetlyWashers
//
//  Created by Matt Westcott on 18/10/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

class CancelWashViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cancellationPicker: UIPickerView!

    var cancellationReason = ["Zombies attacked", "Seagulls won't stop pooping", "Car upside down", "I need an adult", "The beach looks more fun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancellationPicker.delegate = self
        self.cancellationPicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cancellationReason.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cancellationReason[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(cancellationReason[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = cancellationReason[row]
        pickerLabel.font = UIFont(name: "Gibson-Light", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}
