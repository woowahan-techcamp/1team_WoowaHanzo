//
//  TabBarController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 18..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {
    var viewControllerToSelect: UIViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    func showLeavingAlert() {
        let leavingAlert = UIAlertController(title: "Warning", message: "Do you want to save before you leave?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            //let delayTime = DispatchTime.now(dispatch_time_t(DispatchTime.now()), Int64(1 * Double(NSEC_PER_SEC)))
            //dispatch_after(delayTime, DispatchQueue.main) {
                // switch viewcontroller after one second delay (faked save action)
                self.performSwitch()
            }
        }
        leavingAlert.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            // switch viewcontroller immediately
            self.performSwitch()
        }
        leavingAlert.addAction(cancelAction)
        
        present(leavingAlert, animated: true, completion: nil)
    }
    
    func performSwitch() {
        if let viewControllerToSelect = viewControllerToSelect {
            // switch viewcontroller immediately
            selectedViewController = viewControllerToSelect
            // reset reference
            self.viewControllerToSelect = nil
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if let navigationController = selectedViewController as? UINavigationController, let _ = navigationController.visibleViewController as? FavoritesViewController {
            // save a reference to the viewcontroller the user wants to switch to
            viewControllerToSelect = viewController
            
            // present the alert
            showLeavingAlert()
            
            // return false so that the tabs do not get switched immediately
            return false
        }
        
        return true
    }
}
