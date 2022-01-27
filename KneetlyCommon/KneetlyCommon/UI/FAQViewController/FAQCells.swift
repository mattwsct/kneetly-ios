//
//  FAQCell.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 24.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

protocol FAQCell {
    
    func configure(faq: FAQ)
}

class FAQQuestionCell: UITableViewCell, FAQCell {
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    
    // MARK: - Initial configuration
    
    func configure(faq: FAQ) {
        questionLabel.text = faq.title
        arrowImage.image = faq.expanded ? R.image.circleArrowDown() : R.image.circleArrowRight()
    }
}

class FAQAnswerCell: UITableViewCell, FAQCell {
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Initial configuration
    
    func configure(faq: FAQ) {
        textView.text = faq.description
    }
}
