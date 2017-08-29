//
//  NickNameClickResultViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Kingfisher

class NickNameClickResultViewController: UIViewController,NVActivityIndicatorViewable {
    
    var ref: DatabaseReference!
    
    var thumnailImage : UIImage = UIImage()
    
    var count  = 0
    
    var myInfoView: MyInfoView = MyInfoView(frame: CGRect(x: 0, y: 68, width: 0, height: 0))
    var myListView : UserListView!
    
    //MARK:닉네임 클릭시 오는 ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        print("we are NickNameClickResultViewController")
        print(User.currentUserName)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        self.title = "\(User.currentUserName)"
        //User.nickNameClickResult배열에 해당 닉네임 유저 글 시간순으로 들어가있음.
        //print(User.nickNameClickResult.count)
    }
   
    

}
