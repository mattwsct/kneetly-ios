//
//  WizardHeaderView.swift
//  KneetlyUsers
//
//  Created by Matt Westcott on 24.11.16.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol WizardHeaderViewDelegate {
    func countOfItemsInWizardHeader(_ wizardHeaderView:WizardHeaderView) -> Int
    func wizardHeader(_ wizardHeaderView: WizardHeaderView, titleForItemWithIndex index: Int) -> String?
    func wizardHeader(_ wizardHeaderView: WizardHeaderView, didSelectItemWithIndex index: Int) -> Bool
}

class WizardHeaderView: UIView {
    
    private var contentView: UIView!
    var buttons: [UIButton] = []
    
    weak var delegate: WizardHeaderViewDelegate?
    var padding: CGFloat = 10.0
    var selectedItem: Int = 0 {
        willSet {
            guard selectedItem != newValue else { return }
            setButton(index: selectedItem, selected: false)
            setButton(index: newValue, selected: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    private func loadView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
        }
    }
    
    func reloadData() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        buttons = []
        
        guard let delegate = delegate else { return }
        let countOfTitles = delegate.countOfItemsInWizardHeader(self)
        
        var stackedViews: [UIView] = []
        for indx in 0..<countOfTitles {
            let titleButton = createTitleButton(index: indx)
            buttons.append(titleButton)
            
            titleButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
            
            contentView.addSubview(titleButton)
            stackedViews.append(titleButton)
            
            if indx < countOfTitles - 1 {
                let separator = createSeparatorView()
                contentView.addSubview(separator)
                stackedViews.append(separator)
            }
            
            setButton(index: indx, selected: false)
        }
        
        setButton(index: selectedItem, selected: true)
        
        contentView.addConstraints(forViews: stackedViews, stackedHorizontallyWithPadding: padding)
    }
    
    private func createTitleButton(index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(delegate?.wizardHeader(self, titleForItemWithIndex: index), for: .normal)
        button.setTitleColor(R.color.kneetly.navyTone3(), for: .normal)
        button.setTitleColor(R.color.kneetly.textPaleGray(), for: .disabled)
        button.setTitleColor(R.color.kneetly.navyTone1(), for: .selected)
        button.setTitleColor(R.color.kneetly.navyTone1(), for: .highlighted)
        button.titleLabel?.font = UIFont.kneetly.headerFont()
        button.addTarget(self, action: #selector(onTitleButtonClicked(sender:)), for:.touchUpInside)
        button.tag = index
        return button
    }
    
    private func setButton(index: Int, selected: Bool) {
        guard let button = buttons[safe: index] else { return }
        button.isSelected = selected
    }
    
    private func createSeparatorView() -> UIView {
        return UIImageView(image: R.image.headerArrow())
    }
    
    @objc private func onTitleButtonClicked(sender: UIButton) {
        let index = sender.tag
        
        let isMoved = self.delegate?.wizardHeader(self, didSelectItemWithIndex: index) ?? false
        
        if isMoved {
            self.selectedItem = index
        }
    }
}
