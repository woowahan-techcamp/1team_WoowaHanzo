//
//  FirebaseModel.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import Firebase

class FirebaseModel{
    
    
    var ref: DatabaseReference!
    
    func postReview(review: String, userID: String, tagArray:[String], timestamp: Int){
        ref = Database.database().reference()
        let key = ref.child("posts").childByAutoId().key
        let post = ["author":userID,
                    "body": review,
                    "tagArray": tagArray, 
                    "timestamp": timestamp] as [String : Any]
        let childUpdates = ["/posts/\(key)": post]
        ref.updateChildValues(childUpdates)
    }
    
    
    func loadFeed(){
        
        self.ref = Database.database().reference().child("posts")
        
        self.ref.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                User.users = [User]()
                for child in result {
                    print(child)
                    var userKey = child.key as! String
                    //print(child.childSnapshot(forPath: "author").value!)
                    let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tagsArray: child.childSnapshot(forPath: "tagArray").value as? [String] ?? nil )
                    User.users.append(user)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                }
                
            }
        })
        
            
    }
}
