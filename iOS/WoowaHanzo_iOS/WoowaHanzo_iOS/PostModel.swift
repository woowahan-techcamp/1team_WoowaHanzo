//
//  PostModel.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import Firebase

class PostModel{
    var ref: DatabaseReference!
    func postReview(review: String, userID: String){
        ref = Database.database().reference()
        let key = ref.child("posts").childByAutoId().key
        let post = ["userID":userID,
                    "review": review]
        let childUpdates = ["/posts/\(key)": post]
        ref.updateChildValues(childUpdates)
    }
}
