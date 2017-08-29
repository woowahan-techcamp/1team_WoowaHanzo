
//  MainPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FTImageViewer
import Firebase

class MainPageViewController: UIViewController,NVActivityIndicatorViewable{
    
    var ref: DatabaseReference!
    var tagResultArray : [String]?

    var firebaseModel = FirebaseModel()
    let cellSpacingHeight: CGFloat = 15
  
   
    var foodArray = [UIImage]()
    var userListView : UserListView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(nickNameLabelTouchedOnMainpage(_ :)), name: NSNotification.Name(rawValue: "nickNameLabelTouchedOnMainpage"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "users2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImg), name: NSNotification.Name(rawValue: "profileimg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeButton), name: NSNotification.Name(rawValue: "likestatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeLabel), name: NSNotification.Name(rawValue: "likenum"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTagResultPageFromMain(_ :)), name: NSNotification.Name(rawValue: "showTagResultPageFromMain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getTagResultPageFromMain(_ :)), name: NSNotification.Name(rawValue: "tagResultToMain"), object: nil)
        
//        searchBar.alpha = 0
//        searchBar.searchBarStyle = UISearchBarStyle.minimal
        let titleAttributes = [
            NSFontAttributeName: UIFont(name:"NotoSans-Bold", size: 19.0)!
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
       
     
    }
    func getTagResultPageFromMain( _ notification:Notification){
        tagResultArray = []
        self.ref = Database.database().reference().child("tagQuery")
        let refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.hasChildren(){
                let postDict = snapshot.value as! [String : Any]
                if let result = snapshot.childSnapshot(forPath: notification.userInfo?["key"] as! String).childSnapshot(forPath: "queryResult").value {
                    self.tagResultArray = []
                    self.tagResultArray = result as? [String]
                    
                }
                if (self.tagResultArray?.count ?? 0) > 1 {

                    
                    //TagResultViewController로 노티를 보낸다.
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendResultViewController"), object: self, userInfo: ["tagResultArray": self.tagResultArray])
                }
            }
        })
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
    
    func nickNameLabelTouchedOnMainpage(_ notification:Notification){
        User.currentUserName = notification.userInfo?["NickNameLabel"] as! String
        
        let storyboard = UIStoryboard(name: "NickNameClickResult", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NickNameClickResultViewController")
        FirebaseModel().ReturnNickNameClickResult()
        self.show(controller, sender: self)
    }
    
    //나중에 completion handler 로 바꿔보자.
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
    
  
   
    func viewload(_ notification: Notification){
        
        userListView.addUserList(users: User.users)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "users2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImg), name: NSNotification.Name(rawValue: "profileimg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeButton), name: NSNotification.Name(rawValue: "likestatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeLabel), name: NSNotification.Name(rawValue: "likenum"), object: nil)
         userListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        //FirebaseModel().loadMainFeed()
        self.view.addSubview(userListView)
        
        let size = CGSize(width: 30, height: 30)

        DispatchQueue.main.async {
            self.startAnimating(size, message: "Loading...", type: .ballTrianglePath)
            //self.firebaseModel.loadFeed()
            FirebaseModel().loadMainFeed()
        }

        
      
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
            
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(nickNameLabelTouchedOnMainpage(_ :)), name: NSNotification.Name(rawValue: "nickNameLabelTouchedOnMainpage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTagResultPageFromMain(_ :)), name: NSNotification.Name(rawValue: "showTagResultPageFromMain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getTagResultPageFromMain(_ :)), name: NSNotification.Name(rawValue: "tagResultToMain"), object: nil)
        userListView.removeFromSuperview()
    }
    
    //스크롤하면 키보드가 사라진다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
   

    func tap(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        //print("tap from \(label.text!)")
    }
 
}

