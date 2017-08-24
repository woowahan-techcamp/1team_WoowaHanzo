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

class MyPageViewController: UIViewController {
    
    var ref: DatabaseReference!

    
    var postProfileImageName:String = ""
    
    
    
    @IBOutlet weak var myInfoView: UIView!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sayhiLabel: UILabel!
    @IBOutlet weak var postnumLabel: UILabel!
    @IBOutlet weak var myProfileImageView: UIImageView!
    var count  = 0
    
    
    var myListView : UserListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(loadUserInfo), name: NSNotification.Name(rawValue: "loadUserInfo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadPorfileImage(_ :)), name: NSNotification.Name(rawValue: "ReturnProfileImageURL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "users3"), object: nil)
        myListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        myListView.ypos = 250
        myInfoView.frame = CGRect(x: 0, y: 5, width: self.view.frame.width, height: 250)
        myListView.addSubview(myInfoView)
        
        myProfileImageView.layer.cornerRadius = myProfileImageView.frame.width / 2
        myProfileImageView.clipsToBounds = true
        
        FirebaseModel().loadProfileImageFromUsers()
        UINavigationBar.appearance().backgroundColor = UIColor.white
        if AuthModel.isLoginStatus(){
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
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    func viewload(_ notification: Notification){
        self.navigationController?.navigationBar.topItem?.title =  User.currentLoginedUserNickName
        nameLabel.text = User.currentLoginedUserNickName
        nameLabel.sizeToFit()
        print("\(User.myUsers.count)개의 랭크 데이터가 존재합니다.")
        myListView.addUserList(users: User.myUsers)
        postnumLabel.text = "게시물 \(User.myUsers.count)"
        postnumLabel.sizeToFit()
        postnumLabel.frame.origin.x = self.view.frame.width / 2 - postnumLabel.frame.width / 2
    }
    func loadUserInfo(){
        self.navigationController?.navigationBar.topItem?.title =  User.currentLoginedUserNickName
        print("loadUserInfo")

    }
    func loadPorfileImage(_ notification : Notification){
        let profileImageUrl = notification.userInfo?["profileImageUrl"] as! String
        Storage.storage().reference(withPath: "profileImages/" + profileImageUrl).downloadURL { (url, error) in
            self.myProfileImageView?.kf.setImage(with: url)
        }
    }
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
            self.present(controller, animated: false, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !AuthModel.isLoginStatus(){
            
            var alert = UIAlertController(title: "로그인 후 이용하실 수 있습니다. ", message: "로그인 하시겠습니까?", preferredStyle: .alert)
            var cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
                self.present(controller, animated: false, completion: nil)
                //self.navigationController?.pushViewController(controller, animated: true)
                //self.show(controller, sender: self)
            })
            var ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginNavigation")
                //self.present(controller, animated: true, completion: nil)
                //self.navigationController?.pushViewController(controller, animated: true)
                self.show(controller, sender: self)
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else{
            //로그인이 되었다면? 내 마이페이지를 보여줘야함.
            FirebaseModel().loadUsers3(username: UserDefaults.standard.string(forKey: "userNickName")!)
            self.view.addSubview(myListView)
            
            }
        
    }
    func imageViewTouched(){
        print("touched")
    }




}


