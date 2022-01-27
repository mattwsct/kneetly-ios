//
//  UIVIewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 08.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import MBProgressHUD

public extension UIViewController {
    @IBAction public func navigateBackAnimated() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction public func navigateToRootAnimated() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

public extension UIViewController {
    public func showProgress(forView: UIView? = nil) {
        MBProgressHUD.showAdded(to: forView ?? view, animated: true)
    }
    
    public func hideProgress(forView: UIView? = nil) {
        MBProgressHUD.hide(for: forView ?? view, animated: true)
    }
}

public extension UIViewController {
    
    public enum ContentLoadingState {
        case started, ended(success: Bool)
    }
    
    public func handleDataLoading<T>(withDataSource dataSource: DataSource<T>,
                                  state: DataSourceState,
                                  contentReloadHandler: ()->(),
                                  loadingStateHandler: ((ContentLoadingState)->())? = nil) {
        let hudTag = 1000
        
        var hud: MBProgressHUD?
        func onStopLoading(withSuccess success: Bool) {
            if let loadingStateHandler = loadingStateHandler {
                loadingStateHandler(.ended(success: success))
            }
            else {
                let hud = view.viewWithTag(hudTag) as? MBProgressHUD
                hud?.hide(animated: true)
            }
        }
        switch state {
        case .loading:
            if let loadingStateHandler = loadingStateHandler {
                loadingStateHandler(.started)
            }
            else {
                hud = MBProgressHUD.showAdded(to: view, animated: true)
                hud?.tag = hudTag
            }
        case .loaded:
            onStopLoading(withSuccess: true)
            contentReloadHandler()
        case .failed(let error):
            onStopLoading(withSuccess: false)
            if error.type.isNoConnectionError {
                KneetlyAlert.show(errorMessage: R.string.localized.commonLoadDataErrorNoConnection(),
                                  buttonTitle: R.string.localized.commonLoadDataErrorRetry(),
                                  buttonHandler: { dataSource.reload() })
            }
            else {
                KneetlyAlert.show(errorMessage: R.string.localized.commonLoadDataErrorUnknown())
            }
        default: break
        }
    }
    
}
 
