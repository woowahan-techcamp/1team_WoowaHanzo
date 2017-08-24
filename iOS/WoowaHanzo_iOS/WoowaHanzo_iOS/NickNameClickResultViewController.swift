//
//  NickNameClickResultViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase

class NickNameClickResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("we are NickNameClickResultViewController")
        print(User.currentUserName)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        self.title = "\(User.currentUserName)님의 마이페이지"
        //User.nickNameClickResult배열에 해당 닉네임 유저 글 시간순으로 들어가있음. 
 
    }
    

}
