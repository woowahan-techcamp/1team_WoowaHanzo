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
                        
                        print(User.currentLoginedUserNickName,User.currentLoginedUserTitle)
                        //여기에 해당 유저의 정보를 파베에서 불러오도록 하자.
                        self.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    else{
                        self.stopAnimating()
                        self.emailValidationLabel.isHidden = false

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
}
