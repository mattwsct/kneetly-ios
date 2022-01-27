//
//  ReferralViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 10.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import Branch

open class ReferralLink {
    
    open static let codeKey = "referralCode"
    
    open static func create(code: String, shareService: ShareServiceType?) -> String? {
        let linkObject = BranchUniversalObject(title: "Referral code") // TODO
        linkObject.contentDescription = "" // TODO
        linkObject.imageUrl = nil // TODO
        linkObject.addMetadataKey(codeKey, value: code)
        
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "sharing"
        linkProperties.channel = shareService?.socialServiceType ?? ""
        
        return linkObject.getShortUrl(with: linkProperties)
    }
}

open class ReferralLabel: CopyableLabel {
    
    open override func copy(_ sender: Any?) {
        UIPasteboard.general.string = ReferralLink.create(code: text ?? "", shareService: nil) ?? ""
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
}

open class ReferralViewController: UIViewController {
    
    @IBOutlet weak var codeLabel: ReferralLabel!
    
    open var dataSource: DataSource<ReferralCode>!
    
    private var referralCode: String {
        get {
            return self.dataSource.object?.referralCode ?? ""
        }
    }
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.reload() { [unowned self] in
            self.codeLabel.text = self.referralCode
        }
    }
    
    // MARK: - Actions
    
    @IBAction func shareOnFacebook() {
        Share.service.presentViewController(service: .facebook, sharedText: createLink(shareService: .facebook) ?? "")
    }
    
    @IBAction func shareOnTwitter() {
        Share.service.presentViewController(service: .twitter, sharedText: createLink(shareService: .twitter) ?? "")
    }
    
    @IBAction func shareOniPhone() {
        Share.service.presentViewController(service: .sms, sharedText: createLink(shareService: .sms) ?? "")
    }
    
    // MARK: - Helpers
    
    private func createLink(shareService: ShareServiceType) -> String? {
        return ReferralLink.create(code: referralCode, shareService: shareService)
    }
}
