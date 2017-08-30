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
   

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        myListView.removeFromSuperview()
    }
    func registerObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserInfo), name: NSNotification.Name(rawValue: "LoadUserInfo3"), object: nil)
        //observer 쌓이는 것 해결 필요
        //NotificationCenter.default.addObserver(self, selector: #selector(loadPorfileImage), name: NSNotification.Name(rawValue: "ReturnProfileImageURL2"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(showTagResultPageFromMain(_ :)), name: NSNotification.Name(rawValue: "showTagResultPageFromMain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewFeeds), name: NSNotification.Name(rawValue: "users3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImg), name: NSNotification.Name(rawValue: "profileimg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeButton), name: NSNotification.Name(rawValue: "likestatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeLabel), name: NSNotification.Name(rawValue: "likenum"), object: nil)
    }
    
    func viewload(){
        self.navigationController?.navigationBar.topItem?.title =  User.currentUserName
        myInfoView.nickNameLabel.text = User.currentUserName
        myInfoView.nickNameLabel.sizeToFit()
        myInfoView.nickNameLabel.frame.origin.x = self.view.frame.width / 2 - myInfoView.nickNameLabel.frame.width / 2
        
        myInfoView.sayHiLabel.text = User.currentUserSayHi
        myInfoView.sayHiLabel.sizeToFit()
        myInfoView.sayHiLabel.frame.origin.x = self.view.frame.width / 2 - myInfoView.sayHiLabel.frame.width / 2
        //지금 viewload가 두번 호출?
        FirebaseModel().loadPersonalFeed(username: User.currentUserName)
        
    }
    func viewFeeds(){
        if AuthModel.isLoginStatus(), User.myUsers.count > 0 {
            print("\(User.myUsers.count)개의 피드 데이터가 존재합니다.")
            myListView.addUserList(users: User.myUsers)
            myInfoView.postNumLabel.text = "게시물 \(User.myUsers.count)"
            myInfoView.postNumLabel.sizeToFit()
            myInfoView.postNumLabel.frame.origin.x = self.view.frame.width / 2 -  myInfoView.postNumLabel.frame.width / 2
        }
    }
    func loadUserInfo(){
        print("call loadUserInfo")
        //FirebaseModel().loadOtherUserInfo(username: User.currentUserName)
        viewload()
        loadPorfileImage()
        // 나중에 바꾸기.
        print("loadUserInfo/////////////////////////")
        
    }
    
    func loadPorfileImage(){
        // self.myProfileImageView.image = User.imageview.image
        //let profileImageUrl = notification.userInfo?["profileImageUrl"] as! String
        Storage.storage().reference(withPath: "profileImages/" + User.currentUserProfileImageUrl).downloadURL { (url, error) in
            if error == nil{
                self.myInfoView.profileImageView.kf.setImage(with: url)
            }
            else{
                self.myInfoView.profileImageView.image = self.thumnailImage
                self.myInfoView.profileImageView.image = UIImage(named: "profile.png")
                
            }
            //self.myProfileImageView.image = User.currentLoginedProfileImage
            //completion handler 등으로 user에 저장해놓기
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("a1")
        registerObservers()
        print("a2")
        myListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        print("a3")
        let size = CGSize(width: 30, height: 30)
        
        DispatchQueue.main.async {
            self.startAnimating(size, message: "Loading...", type: .ballTrianglePath)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            self.stopAnimating()
        }
        print("a4")
        self.navigationController?.navigationBar.topItem?.title = User.currentLoginedUserNickName
        //self.view.setNeedsDisplay()
        //            myListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        myListView.ypos = 313
        print("myINFO")
        myInfoView = MyInfoView(frame: CGRect(x: 0, y: 68, width: self.view.frame.width, height: 250))
        print("myINFO2")
        myListView.addSubview(myInfoView)
        print("a5")
        myInfoView.profileImageView.layer.cornerRadius =  myInfoView.profileImageView.frame.width / 2
        myInfoView.profileImageView.clipsToBounds = true
        
        //FirebaseModel().loadProfileImageFromUsers()
        FirebaseModel().loadOtherUserInfo(username: User.currentUserName)
        print("a6")
        //FirebaseModel().loadPersonalFeed(username: User.currentLoginedUserNickName)
        self.view.addSubview(myListView)
    }
    
    //feed
    func updateProfileImg(_ notification: Notification){
        let profileimg = notification.userInfo?["profileimg"] as? String ?? nil
        let imageview = notification.userInfo?["imgview"] as? UIImageView ?? nil
        let ranknamelabel = notification.userInfo?["ranklabel"] as? UILabel ?? nil
        let rankname = notification.userInfo?["rankname"] as? String ?? ""
        if profileimg != nil && imageview != nil {
            Storage.storage().reference(withPath: "profileImages/" + profileimg!).downloadURL { (url, error) in
                //imageview?.kf.setImage(with: url)
                if error != nil{
                    //imageview?.image = self.thumnailImage
                    imageview?.image = UIImage(named: "profile.png")

                }
                else{
                    imageview?.kf.setImage(with: url)
                    
                }
                
            }
        }
        if ranknamelabel != nil {
            ranknamelabel?.text = rankname
            ranknamelabel?.sizeToFit()
        }
    }
    func updateLikeButton(_ notification: Notification){
        let check = notification.userInfo?["doeslike"] as? Bool ?? false
        let button  = notification.userInfo?["button"] as? LikeButton ?? nil
        if check {
            button?.setImage(#imageLiteral(resourceName: "heartBlue_Final"), for: .normal)
        }
        else{
            button?.setImage(#imageLiteral(resourceName: "emptyHeard"), for: .normal)
            
        }
    }
    func updateLikeLabel(_ notification: Notification){
        let label = notification.userInfo?["label"] as? UILabel ?? nil
        let numstring = notification.userInfo?["num"] as? String ?? ""
        let button = notification.userInfo?["button"] as? LikeButton ?? nil
        if numstring == "0"{
            label?.text = ""
            button?.num = 0
        }
        else{
            label?.text = "\(numstring)명"
            button?.num = Int(numstring)!
            label?.sizeToFit()
        }
    }
    func showTagResultPageFromMain(_ notification: Notification){
        let tagName = notification.userInfo?["tagName"] as! String
        FirebaseModel().tagQuery(tagName: tagName)
        
        ////
        let storyboard = UIStoryboard(name: "TagPage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tagResultMain")  as! TagResultViewController
        controller.tagName = tagName
        self.show(controller, sender: self)
    }
    
    
}
