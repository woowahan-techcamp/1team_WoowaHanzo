//
//  MyPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import BSImagePicker
import Photos
import NVActivityIndicatorView



class MyPageViewController: UIViewController,NVActivityIndicatorViewable {
    
    var ref: DatabaseReference!
    
    
    var postProfileImageName:String = ""
    
    
    
    var count  = 0
    
    var myInfoView: MyInfoView = MyInfoView(frame: CGRect(x: 0, y: 68, width: 0, height: 0))
    var myListView : UserListView!
    func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(nickNameLabelTouchedOnMainpage(_ :)), name: NSNotification.Name(rawValue: "nickNameLabelTouchedOnMainpage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserInfo), name: NSNotification.Name(rawValue: "LoadUserInfo2"), object: nil)
        //observer 쌓이는 것 해결 필요
        NotificationCenter.default.addObserver(self, selector: #selector(loadPorfileImage(_ :)), name: NSNotification.Name(rawValue: "ReturnProfileImageURL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewFeeds), name: NSNotification.Name(rawValue: "users3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImg), name: NSNotification.Name(rawValue: "profileimg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeButton), name: NSNotification.Name(rawValue: "likestatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeLabel), name: NSNotification.Name(rawValue: "likenum"), object: nil)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        registerObservers()
//        myListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        myListView.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("call view did load")
       
       // print(User.myUsers.count,1234566)
        
        
        
        UINavigationBar.appearance().backgroundColor = UIColor.white
        if AuthModel.isLoginStatus(){
            print("logined")
            self.navigationController?.navigationBar.topItem?.title = User.currentLoginedUserNickName
            
        }
        else {
            self.navigationController?.navigationBar.topItem?.title = "마이페이지"
        }
        
        for index in User.users{
            if (AuthModel().returnUsersUid() == index.uid){
                print(index.contents)
            }
        }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTouched))
//        myInfoView.profileImageView.addGestureRecognizer(tap)
//        myInfoView.profileImageView.isUserInteractionEnabled = true
        
        
    }

    func viewload(){
        self.navigationController?.navigationBar.topItem?.title =  User.currentLoginedUserNickName
        myInfoView.nickNameLabel.text = User.currentLoginedUserNickName
        myInfoView.nickNameLabel.sizeToFit()
        myInfoView.nickNameLabel.frame.origin.x = self.view.frame.width / 2 - myInfoView.nickNameLabel.frame.width / 2
        
        myInfoView.sayHiLabel.text = User.currentLoginedUserSayHi
        myInfoView.sayHiLabel.sizeToFit()
        myInfoView.sayHiLabel.frame.origin.x = self.view.frame.width / 2 - myInfoView.sayHiLabel.frame.width / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTouched))
        myInfoView.profileImageView.addGestureRecognizer(tap)
        myInfoView.profileImageView.isUserInteractionEnabled = true
        //지금 viewload가 두번 호출?
        FirebaseModel().loadPersonalFeed(username: User.currentLoginedUserNickName)
        
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
        viewload()
        FirebaseModel().loadProfileImageFromUsers() // 나중에 바꾸기.
        print("loadUserInfo/////////////////////////")
        
    }
    
    func loadPorfileImage(_ notification : Notification){
        // self.myProfileImageView.image = User.imageview.image
        let profileImageUrl = notification.userInfo?["profileImageUrl"] as! String
        Storage.storage().reference(withPath: "profileImages/" + profileImageUrl).downloadURL { (url, error) in
            self.myInfoView.profileImageView.kf.setImage(with: url)
            //self.myProfileImageView.image = User.currentLoginedProfileImage
            //completion handler 등으로 user에 저장해놓기
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if !AuthModel.isLoginStatus(){
            
            let alert = UIAlertController(title: "로그인 후 이용하실 수 있습니다. ", message: "로그인 하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                self.tabBarController?.selectedIndex = 0
            })
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginNavigation")
                self.show(controller, sender: self)
                
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else{
            //로그인이 되었다면? 내 마이페이지를 보여줘야함.
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
            
            FirebaseModel().loadProfileImageFromUsers()
            FirebaseModel().loadUserInfo(pageCase: 2)
            print("a6")
            //FirebaseModel().loadPersonalFeed(username: User.currentLoginedUserNickName)
            self.view.addSubview(myListView)
            
        }
        
    }
    func imageViewTouched(){
        ////여기에 피커.
        let imagePickerController = BSImagePickerViewController()
        imagePickerController.maxNumberOfSelections = 1
        bs_presentImagePickerController(imagePickerController, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected")
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel")
        }, finish: { (assets: [PHAsset]) -> Void in
            //self.imageAssets = assets
            //FirebaseModel().postImages(assets: assets)
            let size = CGSize(width: 30, height: 30)
            
            let asset = assets[0]
            let name = asset.value(forKey:"filename") as! String
            let extlist = name.components(separatedBy: ".")
            let ext = extlist[extlist.count - 1]
            let image = FirebaseModel().getAssetThumbnail(asset: asset)
            FirebaseModel().postProfileImage(asset: asset, name: ("\(Date().timeIntervalSince1970).\(ext)"), uid: (Auth.auth().currentUser?.uid)!)
            
            self.myInfoView.profileImageView.image = image // loadprofileimage랑 약간 겹치는 듯.
            User.imageview.image = image
            print("image changed")
            print("image: \(image)")

        }, completion: nil)
        
        
        print("touched")
    }
    
    //for feeds
    func updateProfileImg(_ notification: Notification){
        let profileimg = notification.userInfo?["profileimg"] as? String ?? nil
        let imageview = notification.userInfo?["imgview"] as? UIImageView ?? nil
        let ranknamelabel = notification.userInfo?["ranklabel"] as? UILabel ?? nil
        let rankname = notification.userInfo?["rankname"] as? String ?? ""
        if profileimg != nil && imageview != nil {
            Storage.storage().reference(withPath: "profileImages/" + profileimg!).downloadURL { (url, error) in
                imageview?.kf.setImage(with: url)
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
            button?.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
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
            label?.text = numstring
            button?.num = Int(numstring)!
            label?.sizeToFit()
        }
    }
    
    func nickNameLabelTouchedOnMainpage(_ notification:Notification){
        User.currentUserName = notification.userInfo?["NickNameLabel"] as! String
    }
    
}


