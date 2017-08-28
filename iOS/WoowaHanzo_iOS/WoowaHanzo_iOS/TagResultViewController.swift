//
//  TagResultViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class TagResultViewController: UIViewController,NVActivityIndicatorViewable {
    
    var ref: DatabaseReference!
    var tagName:String = " "
    var tagFeedArray = [String]()
    var userListView : UserListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getTagFeed(_ :)), name: NSNotification.Name(rawValue: "sendResultViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "tagusersdone"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImg), name: NSNotification.Name(rawValue: "profileimg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeButton), name: NSNotification.Name(rawValue: "likestatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeLabel), name: NSNotification.Name(rawValue: "likenum"), object: nil)
        //print(tagName)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        //self.navigationController?.navigationBar.topItem?.title = "태그"
        self.title = tagName
        self.navigationItem.title = tagName
        userListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let size = CGSize(width: 30, height: 30)
        DispatchQueue.main.async {
            self.startAnimating(size, message: "\(self.tagName)", type: .ballTrianglePath)
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
            
        }
        
    }
    
    func viewload(_ notification: Notification){
       
        userListView.removeFromSuperview()
        userListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        print(User.tagUsers.count)
        userListView.addUserList(users: User.tagUsers)
        self.view.addSubview(userListView)
        User.tagUsers = [User]()
        
    }
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
    
    
    
    
    //MAKR:posts id를 담은 배열(userinfo로 전달해줌.)에서 해당 피드들을 불러와 싱글톤인 User.tagUsers에 저장.
    func getTagFeed(_ notification: Notification){
        User.tagUsers = [User]()
        tagFeedArray = []
        if let notiArray = notification.userInfo?["tagResultArray"]{
            tagFeedArray = notiArray as! [String]
            for i in 1..<tagFeedArray.count{
                for j in 0..<User.users.count{
                    if User.users[j].key == tagFeedArray[i]{
                        let tagUser = User(key: tagFeedArray[i], nickName: User.users[j].nickName, contents: User.users[j].contents, tags: User.users[j].tags, imageArray: User.users[j].imageArray, postDate: User.users[j].postDate,uid:User.users[j].uid)
                        
                        User.tagUsers.append(tagUser)
                        
                    }
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tagusersdone"), object: self)
            
        }
    }
    func tap(_ sender:UIGestureRecognizer){
        let label = (sender.view as! UILabel)
        //print("tap from \(label.text!)")
    }
    
}
