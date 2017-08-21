//
//  TabBarControllerViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is MainPageViewController) {
            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Logout", style: .default) { (action) in
                tabBarController.selectedIndex = 0 //CHANGE ME
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            alertController.addAction(cancelAction)
            tabBarController.present(alertController, animated: true)
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
