import Foundation
import Firebase

class TagUser {
    
    static var tagUsers = Array<TagUser>()
    
    let key : String
    let nickName : String
    var contents : String
    //tag는 없을 수도 있으니, Optional로 선언.
    var tags : [String]?
    //image역시 첨부 안할 수 있으니 Optional로 선언.
    var imageArray : [String]?
    var postDate : Int
    init(key: String,nickName :String, contents :  String, tags : [String]?,imageArray: [String]?,postDate:Int) {
        self.nickName = nickName
        self.contents = contents
        self.key = key
        self.tags = tags
        self.imageArray = imageArray
        self.postDate = postDate
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        nickName = snapshotValue["author"] as! String
        contents = snapshotValue["body"] as! String
        tags = snapshotValue["tags"] as? [String] ?? []
        imageArray = snapshotValue["images"] as? [String] ?? []
        postDate = snapshotValue["time"] as! Int
    }
}
