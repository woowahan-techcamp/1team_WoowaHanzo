//
//  RegisterViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RegisterViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var nickNameCheckLabel: UILabel!
    @IBOutlet weak var pwCheckLabel: UILabel!
    @IBOutlet weak var emailCheckLabel: UILabel!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPwTextField: UITextField!
    
    @IBOutlet weak var nickName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        navigationItem.title = "회원가입"
        nickNameCheckLabel.isHidden = true
        pwCheckLabel.isHidden = true
        emailCheckLabel.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        
        let size = CGSize(width: 30, height: 30)
        
        self.startAnimating(size, message: "먹소리의 회원이 되는 중...", type: .ballTrianglePath)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("먹소리의 회원이 되는중...")
            if let email = self.registerEmailTextField.text,let pw  = self.registerPwTextField.text{
                AuthModel.register(email: email, pw: pw, completion: { (success) in
                    if success{
                        self.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    else{
                        self.stopAnimating()
                        self.emailCheckLabel.isHidden = false
                        self.emailCheckLabel.text = "이미 존재하는 이메일입니다."
                       
                        
                    }
                })
                
            }
        }

        
        
        
        
}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
