//
//  RankModel.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import UIKit
import Firebase


//RankModel을 만들어서, 전달한다.

class RankUser {
    var email : String
    var likes : Int?
    //optional은 필수적이지 않은 것들
    var profileImg : String? // String으로 할지 말지, UIImage로할지.. 결정해야한다.
    var sayhi : String?
    let nickName : String
    
    init(email: String, likes:Int, profileImg: String?, sayhi : String? , nickName: String) {
        self.email = email
        self.likes = likes
        self.profileImg = profileImg
        self.sayhi = sayhi
        self.nickName = nickName
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.email = snapshotValue["email"] as! String
        self.likes = snapshotValue["likes"] as? Int ?? nil
        self.profileImg = snapshotValue["profileImg"] as? String ?? nil
        self.sayhi = snapshotValue["sayhi"] as? String ?? nil
        self.nickName = snapshotValue["username"] as! String
    }

}
