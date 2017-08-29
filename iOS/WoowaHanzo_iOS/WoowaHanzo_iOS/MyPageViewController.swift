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
    
    
    
    @IBOutlet weak var myInfoView: UIView!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeButton), name: NSNotification.Name(rawValue: "likestatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeLabel), name: NSNotification.Name(rawValue: "likenum"), object: nil)
    
        
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

    
        func viewload(){
            self.navigationController?.navigationBar.topItem?.title =  User.currentLoginedUserNickName
            nameLabel.text = User.currentLoginedUserNickName
            nameLabel.sizeToFit()
            nameLabel.frame.origin.x = self.view.frame.width / 2 - nameLabel.frame.width / 2

            sayhiLabel.text = User.currentLoginedUserSayHi
            sayhiLabel.sizeToFit()
            sayhiLabel.frame.origin.x = self.view.frame.width / 2 - sayhiLabel.frame.width / 2

        
            print("\(User.myUsers.count)개의 마이페이지 피드 데이터가 존재합니다.")
            print(User.myUsers.count)
            myListView.addUserList(users: User.myUsers)
            postnumLabel.text = "게시물 \(User.myUsers.count)"
            postnumLabel.sizeToFit()
            postnumLabel.frame.origin.x = self.view.frame.width / 2 - postnumLabel.frame.width / 2
            
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

    
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            
            
            if !AuthModel.isLoginStatus(){
                
                
                //
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
                
                
                let size = CGSize(width: 30, height: 30)
                
                DispatchQueue.main.async {
                    self.startAnimating(size, message: "Loading...", type: .ballTrianglePath)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
                    self.stopAnimating()
                }
                
                self.navigationController?.navigationBar.topItem?.title =  User.currentLoginedUserNickName
                //self.view.setNeedsDisplay()
                myListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                myListView.ypos = 313
                myInfoView.frame = CGRect(x: 0, y: 68, width: self.view.frame.width, height: 250)
                myListView.addSubview(myInfoView)
                
                myProfileImageView.layer.cornerRadius = myProfileImageView.frame.width / 2
                myProfileImageView.clipsToBounds = true
                
                FirebaseModel().loadProfileImageFromUsers()
                FirebaseModel().loadUserInfo()

                FirebaseModel().loadPersonalFeed(username: User.currentLoginedUserNickName)
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


