//
//  GenderPicker.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 29.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import SnapKit

public class GenderPicker: UIControl {
    
    public enum Gender {
        case unknown
        case male
        case female
    }
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    var defaultColor = R.color.kneetly.navyTone3()
    var selectedColor = R.color.kneetly.textDarkBlue()
    var invalidColor = R.color.kneetly.orangeyRed()
    
    public var gender: Gender = .unknown {
        didSet {
            updateAppearance()
            self.sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView() {
        loadNib()
    }
    
    func loadNib() {
        guard let view = R.nib.genderPicker.firstView(owner: self) else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        self.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func updateAppearance() {
        femaleButton.tintColor = defaultColor
        maleButton.tintColor = defaultColor

        switch gender {
        case .female:
            femaleButton.tintColor = selectedColor
        case .male:
            maleButton.tintColor = selectedColor
        case .unknown:
            break
        }
    }

    @IBAction func femaleDidPicked(_ sender: Any) {
        gender = .female
    }
    
    @IBAction func maleDidPicked(_ sender: Any) {
        gender = .male
    }
}
