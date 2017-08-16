//
//  LoginViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailValidationLabel.isHidden = true
    }

    @IBAction func loginButtonTouched(_ sender: Any) {
        if let email = emailTextField.text,let pw  = pwTextField.text{
          AuthModel.login(email: email, pw: pw, completion: { (success) in
            if !success{
                self.emailValidationLabel.isHidden = false
            }
            })
        }
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
