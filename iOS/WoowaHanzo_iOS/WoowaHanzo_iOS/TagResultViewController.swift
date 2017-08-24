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
    
    var tagName:String = ""
    var tagFeedArray = [String]()
    var userListView : UserListView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getTagFeed(_ :)), name: NSNotification.Name(rawValue: "sendResultViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "tagusersdone"), object: nil)

        //print(tagName)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        self.navigationController?.navigationBar.topItem?.title = "태그"
        //self.title = tagName
        self.navigationItem.title = tagName
        userListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))


    }
    
    override func viewWillAppear(_ animated: Bool) {
        let size = CGSize(width: 30, height: 30)
        DispatchQueue.main.async {
            self.startAnimating(size, message: "Loading...", type: .ballTrianglePath)
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
            
        }
    }
    
    func viewload(_ notification: Notification){
        print(User.tagUsers)
        userListView.removeFromSuperview()
        userListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        userListView.addUserList(users: User.tagUsers)
        self.view.addSubview(userListView)
        User.tagUsers = [User]()
        
    }
    
    
   
    func getTagFeed(_ notification: Notification){
        User.tagUsers = [User]()
        tagFeedArray = []
        if let notiArray = notification.userInfo?["tagResultArray"] {
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
    func tap(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("tap from \(label.text!)")
    }
    
}
