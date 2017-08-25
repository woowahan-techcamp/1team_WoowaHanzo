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
    
    @IBOutlet weak var userSayTextView: UITextView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameCheckLabel: UILabel!
    @IBOutlet weak var pwCheckLabel: UILabel!
    @IBOutlet weak var emailCheckLabel: UILabel!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        navigationItem.title = "회원가입"
        nickNameCheckLabel.isHidden = true
        pwCheckLabel.isHidden = true
        emailCheckLabel.isHidden = true
        
        userSayTextView.layer.borderWidth = 1.0
        userSayTextView.layer.borderColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1).cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func emailCheckAction(_ sender: Any) {
        if let email = registerEmailTextField.text{
            if email.isValidEmail(){
                emailCheckLabel.isHidden = true
            }
            else{
                emailCheckLabel.isHidden = false
            }
            
        }
        
    }
    @IBAction func pwCheckAction(_ sender: Any) {
        if !AuthModel.isValidpassword(pw: registerPwTextField.text!){
            pwCheckLabel.isHidden = false
        }
        else{pwCheckLabel.isHidden = true}
        
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
                        AuthModel.saveUser(email: email, profileImg: nil, UserSayText: self.userSayTextView.text, nickName: self.nickNameTextField.text!)
                    }
                    else{
                        self.stopAnimating()
                        self.emailCheckLabel.isHidden = false
                        //self.emailCheckLabel.text = "이미 존재하는 이메일입니다."
                        
                        
                    }
                })
                
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        //위에서 정의한 keyboardWillShow,keyboardWillHide를 selector로 지정한다.
        
    }
    
    //키보드 노티에 관한 것을 구독 취소 해주는 함수 -> 꼭 해줘야한다.
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        //위에서 생성했던 옵저버를 삭제한다.
        
    }
    //키보드가 화면에 나타날 때 수행되는 함수.
    func keyboardWillShow(_ notification:Notification) {
        
        if (userSayTextView?.isFirstResponder)!{
            view.frame.origin.y = 0 - 20
        }
        
    }
    //키보드가 사라질 때 수행되는 함수
    func keyboardWillHide(_ notification:Notification){
        if (userSayTextView?.isFirstResponder)!{
            view.frame.origin.y = view.frame.origin.y + 20
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //키보드 노티 구독.
        subscribeToKeyboardNotifications()
    }
    
    
}
