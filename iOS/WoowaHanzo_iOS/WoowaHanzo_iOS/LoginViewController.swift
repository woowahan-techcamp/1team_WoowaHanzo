//
//  LoginViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class LoginViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailValidationLabel.isHidden = true
    }

    @IBAction func loginButtonTouched(_ sender: Any) {
        self.view.endEditing(true)
        let size = CGSize(width: 30, height: 30)
        
        self.startAnimating(size, message: "Authenticating...", type: .ballTrianglePath)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
            if let email = self.emailTextField.text,let pw  = self.pwTextField.text{
                AuthModel.login(email: email, pw: pw, completion: { (success) in
                    if success{
                        self.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                })
                
            }
        }

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
