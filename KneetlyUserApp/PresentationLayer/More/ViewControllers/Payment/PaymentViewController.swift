//
//  Created by Matt Westcott.
//  Copyright © 2016 Be IT Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon

class PaymentViewController: PaymentMethodViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate enum SectionType: Int {
        case personal = 0
        case business = 1
        
        var title: String {
            switch self {
            case .personal:
                return R.string.localized.paymentMethodsPersonalSectionTitle()
            case .business:
                return R.string.localized.paymentMethodsBusinessSectionTitle()
            }
        }
    }
    
    fileprivate struct Section {
        var type: SectionType
        var items: [String]
    }
    
    fileprivate var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBusiness()
        sections = [Section(type: .personal, items: []), Section(type: .business, items:[])]
        configureTableView()
    }
    
    func getBusiness() {
        showProgress()
        let request = ApiEndpoints.Account.businessList()
        AppDelegate.current().requestSender.sendRequest(apiRequest: request, completion: { (result) in
            self.hideProgress()
            switch result {
            case .success(let businessList):
                if let currentBusiness = businessList.first {
                    self.businessId = currentBusiness.id
                }
                break
            case .failure( _):
                break
            }
        })
    }
    
    fileprivate func addPaymentMethod(forSection section: Section?) {
        guard let section = section else {
            return
        }
        
        switch section.type {
        case .personal:
            presentPaymentMethodsViewController(forBusinessId: nil)
        case .business:
            presentPaymentMethodsViewController(forBusinessId: businessId)
        }
    }
    
    override func didReceivePaymentMethodsNames(_ names: [String], forBusinessId: String?) {
        if forBusinessId == nil {
            sections[SectionType.personal.rawValue].items = names
        }
        else {
            sections[SectionType.business.rawValue].items = names
        }
        tableView.reloadData()
    }
}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func configureTableView() {
        tableView.register(R.nib.paymentSectionHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.paymentSectionHeaderView.name)
        tableView.register(R.nib.paymentSectionFooterView(), forHeaderFooterViewReuseIdentifier: R.nib.paymentSectionFooterView.name)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.paymentMethodTableViewCell, for: indexPath)!
        
        cell.methodNameLabel.text = sections[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentPaymentMethodsViewController(forBusinessId: indexPath.section == SectionType.business.rawValue ? businessId : nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return PaymentSectionHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.paymentSectionHeaderView.name) as? PaymentSectionHeaderView
        headerView?.titleLabel.text = sections[section].type.title
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return PaymentSectionFooterView.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.paymentSectionFooterView.name) as? PaymentSectionFooterView
        footerView?.actionHandler = { [weak self] in
            self?.addPaymentMethod(forSection: self?.sections[section])
        }
        
        return footerView
    }
}
