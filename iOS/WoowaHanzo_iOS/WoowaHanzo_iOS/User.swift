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
    
    let key : String
    let nickName : String
    var contents : String
    //tag는 없을 수도 있으니, Optional로 선언.
    var tagsArray : [String]?
    //image역시 첨부 안할 수 있으니 Optional로 선언.
    var imageArray : [String]?
    init(key: String,nickName :String, contents :  String, tagsArray : [String]?,imageArray: [String]?) {
        self.nickName = nickName
        self.contents = contents
        self.key = key
        self.tagsArray = tagsArray
        self.imageArray = imageArray
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        nickName = snapshotValue["author"] as! String
        contents = snapshotValue["body"] as! String
        tagsArray = snapshotValue["tagArray"] as? [String] ?? []
        imageArray = snapshotValue["images"] as? [String] ?? []
    }
}
