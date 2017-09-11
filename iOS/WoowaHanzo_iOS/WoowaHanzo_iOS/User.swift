//
//  User.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import Firebase


//Feed
class User {
    
    static var users = Array<User>()
    static var tagUsers = Array<User>()
    static var myUsers = Array<User>()
    static var currentFoodImage = UIImage()
    
    //닉네임 클릭 용 유저 네임
    static var currentUserName : String = " "
    static var currentUserSayHi :String = " "
    static var currentUserProfileImageUrl :String = " "
    
    
    
    
    
    static var nickNameClickResult = Array<User>()
    static var currentLoginedUserNickName : String = ""
    static var currentLoginedUserRankName : String = ""
    static var currentLoginedUserLikes : Int = 0
    static var currentLoginedUserSayHi : String = ""
    static var currentLoginedUserUid : String = ""
    static var imageview : UIImageView = UIImageView(image: UIImage(named:
        "profile.png"))
    
    
    
    static var currentLoginedUserTitle : String = ""
    static var currentUserProfileImage = UIImage()
    
    let key : String
    let nickName : String
    var contents : String
    //tag는 없을 수도 있으니, Optional로 선언.
    var tags : [String]?
    //image역시 첨부 안할 수 있으니 Optional로 선언.
    var imageArray : [String]?
    var postDate : Int
    var uid : String
    init(key: String,nickName : String, contents : String, tags : [String]?,imageArray: [String]?,postDate:Int, uid: String) {
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
