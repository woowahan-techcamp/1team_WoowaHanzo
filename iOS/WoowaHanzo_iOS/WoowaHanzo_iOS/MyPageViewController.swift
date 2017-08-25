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


class MyPageViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    
    var postProfileImageName:String = ""
    
    
    
    @IBOutlet weak var myInfoView: UIView!
    
    //@IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sayhiLabel: UILabel!
    @IBOutlet weak var postnumLabel: UILabel!
    @IBOutlet weak var myProfileImageView: UIImageView!
    var count  = 0
    
    
    var myListView : UserListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(nickNameLabelTouchedOnMainpage(_ :)), name: NSNotification.Name(rawValue: "nickNameLabelTouchedOnMainpage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserInfo), name: NSNotification.Name(rawValue: "LoadUserInfo"), object: nil)
        //observer 쌓이는 것 해결 필요
        NotificationCenter.default.addObserver(self, selector: #selector(loadPorfileImage(_ :)), name: NSNotification.Name(rawValue: "ReturnProfileImageURL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "users3"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImg), name: NSNotification.Name(rawValue: "profileimg"), object: nil)
        
        
//        myListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        myListView.ypos = 250
//        myInfoView.frame = CGRect(x: 0, y: 5, width: self.view.frame.width, height: 250)
//        myListView.addSubview(myInfoView)
//        
//        myProfileImageView.layer.cornerRadius = myProfileImageView.frame.width / 2
//        myProfileImageView.clipsToBounds = true
//        
//        FirebaseModel().loadProfileImageFromUsers()
//        FirebaseModel().loadUserInfo()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTouched))
        myProfileImageView.addGestureRecognizer(tap)
        myProfileImageView.isUserInteractionEnabled = true
        
        
    }
//    func loadUserInfo(){
//        self.navigationController?.navigationBar.topItem?.title = User.currentLoginedUserNickName
//        print("loadUserInfo")
//    }
    
        func viewload(){
            self.navigationController?.navigationBar.topItem?.title =  User.currentLoginedUserNickName
            nameLabel.text = User.currentLoginedUserNickName
            nameLabel.sizeToFit()
            sayhiLabel.text = User.currentLoginedUserSayHi
            sayhiLabel.sizeToFit()
        
            print("\(User.myUsers.count)개의 피드 데이터가 존재합니다.")
            myListView.addUserList(users: User.myUsers)
            postnumLabel.text = "게시물 \(User.myUsers.count)"
            postnumLabel.sizeToFit()
            postnumLabel.frame.origin.x = self.view.frame.width / 2 - postnumLabel.frame.width / 2
            //logoutButton.tintColor = UIColor.blue
            
        }
        
        
        
        func loadUserInfo(){
            viewload()
            FirebaseModel().loadProfileImageFromUsers() // 나중에 바꾸기.
            print("loadUserInfo/////////////////////////")
            
        }
        
        func loadPorfileImage(_ notification : Notification){
            self.myProfileImageView.image = User.imageview.image
//            let profileImageUrl = notification.userInfo?["profileImageUrl"] as! String
//            Storage.storage().reference(withPath: "profileImages/" + profileImageUrl).downloadURL { (url, error) in
//                self.myProfileImageView?.kf.setImage(with: url)
//                //self.myProfileImageView.image = User.currentLoginedProfileImage
//                //completion handler 등으로 user에 저장해놓기
//            }
        }
//        @IBAction func logout(_ sender: Any) {
//            let firebaseAuth = Auth.auth()
//            do {
//                try firebaseAuth.signOut()
//                let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
//                self.present(controller, animated: false, completion: nil)
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//            }
//            
//        }
    
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            
            if !AuthModel.isLoginStatus(){
                
                var alert = UIAlertController(title: "로그인 후 이용하실 수 있습니다. ", message: "로그인 하시겠습니까?", preferredStyle: .alert)
                var cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                    //                let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
                    //                let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
                    //                self.present(controller, animated: false, completion: nil)
                    //self.navigationController?.pushViewController(controller, animated: true)
                    //self.show(controller, sender: self)
                    self.tabBarController?.selectedIndex = 0
                })
                var ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
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
                self.navigationController?.navigationBar.topItem?.title =  User.currentLoginedUserNickName
                self.view.setNeedsDisplay()
                myListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                myListView.ypos = 313
                myInfoView.frame = CGRect(x: 0, y: 68, width: self.view.frame.width, height: 250)
                myListView.addSubview(myInfoView)
                
                myProfileImageView.layer.cornerRadius = myProfileImageView.frame.width / 2
                myProfileImageView.clipsToBounds = true
                
                FirebaseModel().loadProfileImageFromUsers()
                FirebaseModel().loadUserInfo()
                FirebaseModel().loadUsers3(username: User.currentLoginedUserNickName)
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
                let asset = assets[0]
                let name = asset.value(forKey:"filename") as! String
                let extlist = name.components(separatedBy: ".")
                let ext = extlist[extlist.count - 1]
                let image = FirebaseModel().getAssetThumbnail(asset: asset)
                FirebaseModel().postProfileImage(asset: asset, name: ("\(Date().timeIntervalSince1970).\(ext)"), uid: (Auth.auth().currentUser?.uid)!)
                
                self.myProfileImageView.image = image // loadprofileimage랑 약간 겹치는 듯.
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
    func nickNameLabelTouchedOnMainpage(_ notification:Notification){
        User.currentUserName = notification.userInfo?["NickNameLabel"] as! String
        
//        print("nickNameLabelTouched")
//        
//        let storyboard = UIStoryboard(name: "NickNameClickResult", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "NickNameClickResultViewController")
//        FirebaseModel().ReturnNickNameClickResult()
//        self.show(controller, sender: self)
    }
    
        
        
        
}


