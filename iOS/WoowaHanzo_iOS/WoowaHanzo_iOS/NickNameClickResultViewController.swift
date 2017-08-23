//
//  NickNameClickResultViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class NickNameClickResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                print("we are NickNameClickResultViewController")
        print(User.currentUserName)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
