//
//  DamageViewController.swift
//  KneetlyWashers
//
//  Created by Matt Westcott on 11/10/16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit

class DamageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var damagePicker: UIPickerView!
    var damageLocation = ["Bonnet/Front", "Front Left", "Front Right", "Middle Left", "Middle Right", "Rear Left", "Rear Right", "Boot/Rear", "Roof", "Rims", "Glass", "Interior", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.damagePicker.delegate = self
        self.damagePicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return damageLocation.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return damageLocation[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(damageLocation[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = damageLocation[row]
        pickerLabel.font = UIFont(name: "Gibson-Light", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}
