//
//  LoginViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import TransitionButton

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: TransitionButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonTouched(_ sender: Any) {
        
    }

    
    
    @IBAction func loginCancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
