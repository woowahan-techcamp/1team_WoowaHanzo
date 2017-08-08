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
    var users = [User]()
    var ref: DatabaseReference!
    func postReview(review: String, userID: String){
        ref = Database.database().reference()
        let key = ref.child("posts").childByAutoId().key
        let post = ["userID":userID,
                    "review": review]
        let childUpdates = ["/posts/\(key)": post]
        ref.updateChildValues(childUpdates)
    }
    
    func loadFeed(){
        ref = Database.database().reference()
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    var userKey = child.key as! String
                    print(child.childSnapshot(forPath: "author").value!)
                    let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String)
                    self.users.append(user)
                    
                }
            }
        })
        
    }
    
}
