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
    let key : String
    let nickName : String
    var contents : String
    init(key: String,nickName : String, contents :  String) {
        self.nickName = nickName
        self.contents = contents
        self.key = key
    }
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        nickName = snapshotValue["author"] as! String
        contents = snapshotValue["body"] as! String
    }
}
