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
    
    @IBOutlet weak var tagResultTableView: UITableView!
    var tagName:String = ""
    var tagFeedArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getTagFeed(_ :)), name: NSNotification.Name(rawValue: "sendResultViewController"), object: nil)
        //print(tagName)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        self.navigationController?.navigationBar.topItem?.title = "태그"
        //self.title = tagName
        self.navigationItem.title = tagName
        tagResultTableView.delegate = self
        tagResultTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let size = CGSize(width: 30, height: 30)
        
        DispatchQueue.main.async {
            self.startAnimating(size, message: "Loading...", type: .ballTrianglePath)
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
            
        }

        tagResultTableView.reloadData()
        User.tagUsers = [User]()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tagResultTableView.reloadData()
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
                        print(User.users[j].contents)
                    }
                }
            }
            
        }
        tagResultTableView.reloadData()
        
        
    }
    func tap(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("tap from \(label.text!)")
    }
    
}
extension TagResultViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.tagUsers.count as? Int ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TagResultTableViewCell
        if User.tagUsers.count > 0{
            cell.tagResultNickNameLabel.text = " "
            cell.tagResultTextView.text = " "
            cell.tagResultTagView.reset()
            

            cell.userid = indexPath.row
            cell.tagResultNickNameLabel.text = User.tagUsers[indexPath.row].nickName
            cell.tagResultTextView.text =  User.tagUsers[indexPath.row].contents
            cell.tagResultTimeLabel.text =  String(describing: Date().postTimeDisplay(timestamp: User.tagUsers[indexPath.row].postDate))
            //print(TagUser.tagUsers[indexPath.row].tags)
            //tableView.reloadData()
            //print(TagUser.tagUsers[indexPath.row].imageArray)
            if let tag = User.tagUsers[indexPath.row].tags{
                for index in tag{
                    cell.tagResultTagView.addTag("#"+index, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: UIColor.white,textColor: UIColor.gray)
                }
            }
            DispatchQueue.main.async {
                cell.tagResultFoodCollectionView.reloadData()
            }
            
            return cell
        }
        return cell
    }
}
