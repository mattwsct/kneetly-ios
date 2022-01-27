//
//  KneetlyAlert.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 13/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import SCLAlertView
import AlamofireImage
import SnapKit

public class KneetlyAlert {
    
    static func alert() -> SCLAlertView {
        let contentViewCornerRadius : CGFloat = 20.0
        let showCircularIcon = false
        let appearance = SCLAlertView.SCLAppearance(kDefaultShadowOpacity: 0.5, kTitleHeight: 0.0, kTextFont:R.font.gibsonLight(size: 20)!, kButtonFont: R.font.gibsonLight(size: 18)!, showCloseButton : false, showCircularIcon: showCircularIcon, contentViewCornerRadius: contentViewCornerRadius, buttonCornerRadius: 16.0, titleColor: R.color.kneetly.navyTone1())
        return SCLAlertView(appearance: appearance)
    }
    
    public static func show(title : String, buttonTitle: String? = nil, buttonHandler: (()->())? = nil) {
        let alert = KneetlyAlert.alert()
        let button = alert.addButton(buttonTitle ?? "OK", backgroundColor: UIColor.white, textColor: R.color.kneetly.green2()) {
            buttonHandler?()
        }
        button.layer.borderWidth = 1.0
        button.layer.borderColor = R.color.kneetly.green2().cgColor
        
        _ = alert.showCustom("", subTitle: title, color: UIColor.white, icon: UIImage())
    }
    
    public static func show(errorMessage: String,buttonTitle: String? = nil, buttonHandler: (()->())? = nil) {
        let alert = KneetlyAlert.alert()
        let button = alert.addButton(buttonTitle ?? "OK", backgroundColor: UIColor.white, textColor: R.color.kneetly.orangeyRed()) {
            buttonHandler?()
        }
        
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 216,height: 100))
        
        let mascot = Mascot.init(positive: false)
        let mascotImage = UIImageView.init(image: mascot.image())
        var frame = mascotImage.frame
        frame.origin.x = (216 - frame.size.width)/2.0
        mascotImage.frame = frame
        
        subview.addSubview(mascotImage)
        
        let title = UILabel.init()
        title.textColor = R.color.kneetly.navyTone1()
        title.font = R.font.gibsonLight(size: 18)!
        title.text = errorMessage
        frame.size.width = subview.frame.size.width
        title.frame = frame
        title.textAlignment = .center
        title.numberOfLines = 0
        title.sizeToFit()
        title.center = CGPoint(x: mascotImage.center.x, y: mascotImage.frame.origin.y + mascotImage.frame.size.height + 10 + title.frame.height/2.0)
        
        frame = subview.frame
        frame.size.height = mascotImage.frame.size.height + title.frame.size.height + 10
        subview.frame = frame
        
        subview.addSubview(title)
        
        alert.customSubview = subview
        
        button.layer.borderWidth = 1.0
        button.layer.borderColor = R.color.kneetly.orangeyRed().cgColor
        
        _ = alert.showCustom("", subTitle: "", color: UIColor.white, icon: UIImage())
    }
    
    public static func showBadgeReceivedNotification(title: String, imageURL: String) {
        showPopup(withTitle: title, imageSource: .url(imageURL), buttonTitle: R.string.localized.badgeReceivedNotificationAlertButtonTitle())
    }
    
    public static func showPushNotificationPopup(withTitle title: String, image: UIImage) {
        showPopup(withTitle: title, imageSource: .image(image), buttonTitle: R.string.localized.badgeReceivedNotificationAlertButtonTitle())
    }
    
    enum PopupImageSource {
        case url(String)
        case image(UIImage)
    }
    
    static func showPopup(withTitle title: String, imageSource: PopupImageSource, buttonTitle: String) {
        let alert = KneetlyAlert.alert()
        
        let button = alert.addButton(buttonTitle,
            backgroundColor: UIColor.white,
            textColor: R.color.kneetly.green2()) {}
        button.layer.borderWidth = 1.0
        button.layer.borderColor = R.color.kneetly.green2().cgColor
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints { make in
            make.width.equalTo(220)
        }
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textColor = R.color.kneetly.navyTone1()
        titleLabel.font = R.font.gibsonLight(size: 17)!
        titleLabel.text = title
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
        }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        switch imageSource {
        case .image(let image):
            imageView.image = image
        case .url(let url):
            guard let imageURL = URL(string: url) else {
                return
            }
            imageView.af_setImage(withURL: imageURL)
        }
        
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        let customSubview = UIView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height))
        customSubview.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alert.customSubview = customSubview
        
        _ = alert.showCustom("", subTitle: "", color: UIColor.white, icon: UIImage())
    }
    
    public static func showWithButtons(title: String, buttons: KneetlyAlertButton ...) {
        let alert = KneetlyAlert.alert()
        
        for button in buttons {
            let alertButton = alert.addButton(button.title, backgroundColor: nil, textColor: button.titleColor, action: button.handler)
            alertButton.layer.borderWidth = 1.0
            alertButton.layer.borderColor = button.borderColor.cgColor
        }
        
        _ = alert.showCustom("", subTitle: "\(title)", color: UIColor.white, icon: UIImage())
    }
}

public class KneetlyAlertButton {
    var title: String
    var titleColor: UIColor
    var borderColor: UIColor
    var handler: () -> Void
    
    public init(title: String, titleColor: UIColor, borderColor: UIColor? = nil, handler: @escaping () -> Void) {
        self.title = title
        self.titleColor = titleColor
        self.borderColor = borderColor ?? titleColor
        self.handler = handler
    }
}
