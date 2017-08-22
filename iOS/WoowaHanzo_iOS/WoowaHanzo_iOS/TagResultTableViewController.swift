//
//  TagResultTableViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase

class TagResultTableViewController: UITableViewController {
    
    var ref: DatabaseReference!

    var tagName:String = ""
    var tagFeedArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getTagFeed(_ :)), name: NSNotification.Name(rawValue: "sendResultViewController"), object: nil)
        print(tagName)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        self.navigationController?.navigationBar.topItem?.title = "태그"
       //self.title = tagName
        self.navigationItem.title = tagName
  }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    func getTagFeed(_ notification: Notification){
        
        if let notiArray =  notification.userInfo?["tagResultArray"]{
            tagFeedArray = notiArray as! [String]
        }
        print("\(tagFeedArray)")
        TagUser.tagUsers = [TagUser]()
        self.ref = Database.database().reference().child("posts")
        for index in 0..<tagFeedArray.count{
            self.ref.queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapshot) in
                if let result = snapshot.childSnapshot(forPath: self.tagFeedArray[index]).value  {
                    let dicResult = result as? [String:Any] ?? [:]
                    if dicResult.count > 0 {
                        print(dicResult["author"] as! String)
                    }
                    
                
            
                
    //            if let result = snapshot.childSnapshot(forPath: self.tagFeedArray[index] as! String).value {
//                    print(result)
//                var userKey = child.key as! String
//                //print(child.childSnapshot(forPath: "author").value!)
//                let tagUser = TagUser(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tags: child.childSnapshot(forPath: "tags").value as? [String] ?? nil,imageArray:child.childSnapshot(forPath: "images").value as? [String] ?? nil, postDate : child.childSnapshot(forPath: "time").value as! Int)
//                User.users.append(user)
                

                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TagResultTableViewCell
        cell.tagResultNickNameLabel.text = "dd"
        return cell
    }
     /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
