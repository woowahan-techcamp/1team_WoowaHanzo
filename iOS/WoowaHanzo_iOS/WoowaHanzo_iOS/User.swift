//
//  User.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    static var users = Array<User>()
    static var tagUsers = Array<User>()
    static var currentUserName : String = " "
    
    let key : String
    let nickName : String
    var contents : String
    //tag는 없을 수도 있으니, Optional로 선언.
    var tags : [String]?
    //image역시 첨부 안할 수 있으니 Optional로 선언.
    var imageArray : [String]?
    var postDate : Int
    var uid : String
    init(key: String,nickName :String, contents :  String, tags : [String]?,imageArray: [String]?,postDate:Int, uid: String) {
        self.nickName = nickName
        self.contents = contents
        self.key = key
        self.tags = tags
        self.imageArray = imageArray
        self.postDate = postDate
        self.uid = uid
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        nickName = snapshotValue["author"] as! String
        contents = snapshotValue["body"] as! String
        tags = snapshotValue["tags"] as? [String] ?? []
        imageArray = snapshotValue["images"] as? [String] ?? []
        postDate = snapshotValue["time"] as! Int
        uid  = snapshotValue["uid"] as! String
    }
}
