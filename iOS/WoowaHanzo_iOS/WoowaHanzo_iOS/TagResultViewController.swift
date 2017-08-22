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
        TagUser.tagUsers = [TagUser]()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tagResultTableView.reloadData()
        TagUser.tagUsers = [TagUser]()
        
    }
    
   
    func getTagFeed(_ notification: Notification){
        
        TagUser.tagUsers = [TagUser]()
        tagFeedArray = []
        if let notiArray = notification.userInfo?["tagResultArray"] {
            tagFeedArray = notiArray as! [String]
            for i in 1..<tagFeedArray.count{
                for j in 0..<User.users.count{
                    if User.users[j].key == tagFeedArray[i]{
                        let tagUser = TagUser(key: tagFeedArray[i], nickName: User.users[j].nickName, contents: User.users[j].contents, tags: User.users[j].tags, imageArray: User.users[j].imageArray, postDate: User.users[j].postDate)
                        TagUser.tagUsers.append(tagUser)
                        print(User.users[j].contents)
                    }
                }
            }
            
        }
        tagResultTableView.reloadData()
        
        
    }
    
    
}
extension TagResultViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TagUser.tagUsers.count as? Int ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TagResultTableViewCell
        if TagUser.tagUsers.count > 0{
            cell.tagResultNickNameLabel.text = " "
            cell.tagResultTextView.text = " "
            cell.tagResultNickNameLabel.text = TagUser.tagUsers[indexPath.row].nickName
            cell.tagResultTextView.text =  TagUser.tagUsers[indexPath.row].contents
            cell.tagResultTimeLabel.text =  String(describing: Date().postTimeDisplay(timestamp: TagUser.tagUsers[indexPath.row].postDate))
            print(TagUser.tagUsers[indexPath.row].contents)
            //tableView.reloadData()
            return cell
        }
        return cell
    }
}
