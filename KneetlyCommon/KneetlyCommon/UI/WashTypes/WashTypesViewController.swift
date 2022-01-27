//
//  WashTypesViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 31.01.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit

class WashTypesViewController: UIViewController {
    
    enum WashType {
        case expressWash, expressWashPlus, classicWash, classicWashPlus
        
        static let allTypes = [
            WashType.expressWash,
            WashType.expressWashPlus,
            WashType.classicWash,
            WashType.classicWashPlus
        ]
        
        var title: String {
            get {
                var result = ""
                switch self {
                case .classicWash: result = R.string.localized.washTypesClassicWashTitle()
                case .classicWashPlus: result = R.string.localized.washTypesClassicWashPlusTitle()
                case .expressWash: result = R.string.localized.washTypesExpressWashTitle()
                case .expressWashPlus: result = R.string.localized.washTypesExpressWashPlusTitle()
                }
                return result
            }
        }
        
        var description: String {
            get {
                var result = ""
                switch self {
                case .classicWash: result = R.string.localized.washTypesClassicWashDescription()
                case .classicWashPlus: result = R.string.localized.washTypesClassicWashPlusDescription()
                case .expressWash: result = R.string.localized.washTypesExpressWashDescription()
                case .expressWashPlus: result = R.string.localized.washTypesExpressWashPlusDescription()
                }
                return result
            }
        }
        
        var smallCarPrice: String {
            get {
                var result = ""
                switch self {
                case .classicWash: result = R.string.localized.washTypesClassicWashSmallCarPrice()
                case .classicWashPlus: result = R.string.localized.washTypesClassicWashPlusSmallCarPrice()
                case .expressWash: result = R.string.localized.washTypesExpressWashSmallCarPrice()
                case .expressWashPlus: result = R.string.localized.washTypesExpressWashPlusSmallCarPrice()
                }
                return result
            }
        }
        
        var mediumCarPrice: String {
            get {
                var result = ""
                switch self {
                case .classicWash: result = R.string.localized.washTypesClassicWashMediumCarPrice()
                case .classicWashPlus: result = R.string.localized.washTypesClassicWashPlusMediumCarPrice()
                case .expressWash: result = R.string.localized.washTypesExpressWashMediumCarPrice()
                case .expressWashPlus: result = R.string.localized.washTypesExpressWashPlusMediumCarPrice()
                }
                return result
            }
        }
        
        var largeCarPrice: String {
            get {
                var result = ""
                switch self {
                case .classicWash: result = R.string.localized.washTypesClassicWashLargeCarPrice()
                case .classicWashPlus: result = R.string.localized.washTypesClassicWashPlusLargeCarPrice()
                case .expressWash: result = R.string.localized.washTypesExpressWashLargeCarPrice()
                case .expressWashPlus: result = R.string.localized.washTypesExpressWashPlusLargeCarPrice()
                }
                return result
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? WashTypeDetailsViewController,
           let washType = sender as? WashType {
            detailsVC.type = washType
        }
    }
}

extension WashTypesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WashType.allTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.washTypeCell)!
        cell.configure(washType: WashType.allTypes[indexPath.row])
        return cell
    }
}

extension WashTypesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.washTypesViewController.toDetails, sender: WashType.allTypes[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
