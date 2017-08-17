//
//  RegisterViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPwTextField: UITextField!
    
    @IBOutlet weak var nickName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        navigationItem.title = "회원가입"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        AuthModel.register()
    }

}
