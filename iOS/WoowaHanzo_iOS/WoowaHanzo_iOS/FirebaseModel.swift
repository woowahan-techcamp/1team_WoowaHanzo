//
//  FirebaseModel.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import Firebase
import Photos

class FirebaseModel{
    
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!


    func postReview(review: String, userID: String, tagArray:[String], timestamp: Int, images:[String],uid: String){
        ref = Database.database().reference()
        let key = ref.child("posts").childByAutoId().key
        let post = ["author": userID,
                    "body": review,
                    "tags": tagArray,
                    "time": timestamp,
                    "images": images,
                    "uid": uid] as [String : Any]
        let childUpdates = ["/posts/\(key)": post]
        ref.updateChildValues(childUpdates)
    }
    
    
    
    func postImages(assets:[PHAsset], names:[String]){
        //print("posting: \(assets.count) \(names.count)")
        for i in 0..<assets.count{
            let asset = assets[i]
            let manager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .exact
            requestOptions.deliveryMode = .highQualityFormat;
            
            // Request Image
            DispatchQueue.global().async{
                manager.requestImageData(for: asset, options: requestOptions, resultHandler: { (data, str, orientation, info) -> Void in
                    if let imagedata = data{
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        let ref = Storage.storage().reference(withPath: "images/" + names[i]).putData(imagedata, metadata:metadata)
                        ref.resume()
                    }
                })
            }
        }
    }
    
    //프로필 이미지 수정할 때
    func postProfileImage(asset:PHAsset, name: String, uid:String){
        ref2 = Database.database().reference()
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.deliveryMode = .highQualityFormat;
        DispatchQueue.global().async{
            manager.requestImageData(for: asset, options: requestOptions, resultHandler: { (data, str, orientation, info) -> Void in
                if let imagedata = data{
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    var ref = Storage.storage().reference(withPath: "profileImages/" + name).putData(imagedata, metadata:metadata)
                    ref.resume()
                    self.ref2.child("users/\(uid)/profileImg").setValue(name)
                }
            })
        }
    }
    
    
    //썸네일 리턴 함수. 리뷰 포스트 뷰에서 사용
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    //
    func tagQuery(tagName:String){
        
        //태그쿼리 작성. key를 저장해서 노티로 보내준다.
        ref = Database.database().reference()
        let key = ref.child("tagQuery").childByAutoId().key
        //print(key)
        let post = ["queryResult": "1" ,"tag": tagName] as [String : String]
        let childUpdates = ["/tagQuery/\(key)": post]
        ref.updateChildValues(childUpdates)
        
        //태그쿼리의 key를 가지는 애를 가져와야함. TagPageViewController로 이어진다. 
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tagResult"), object: self, userInfo: ["key":key])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tagResultToMain"), object: self, userInfo: ["key":key])
        
    }

    func ReturnNickNameClickResult(){
        
        self.ref = Database.database().reference().child("posts")
        
        self.ref.queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                User.nickNameClickResult = [User]()
                for child in result {
                    if (child.childSnapshot(forPath: "author").value as! String == User.currentUserName){
                        var userKey = child.key as! String
                        //print(child.childSnapshot(forPath: "author").value!)
                        let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tags: child.childSnapshot(forPath: "tags").value as? [String] ?? nil,imageArray:child.childSnapshot(forPath: "images").value as? [String] ?? nil, postDate : child.childSnapshot(forPath: "time").value as! Int, uid: child.childSnapshot(forPath: "uid").value as! String)
                            User.nickNameClickResult.append(user)
                        //print(child.childSnapshot(forPath: "body").value as! String)
                        
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                    }
                }
                
                
                
            }
        })
        
        
    }

    
    //For RankPage////////////////////////////////////
    func loadRanks(){
        var rankUserList = [RankUser]()
        self.ref = Database.database().reference().child("users")
        //나중에 Likes가 확보되면  likes로 바꾸기.
        self.ref.queryOrdered(byChild: "likes").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                //result.count = 0 일 때 처리 필요할 수도 있다.
                for index in 0...result.count - 1 {
                    let child = result[result.count - 1 - index]
                    let rankuser = RankUser(snapshot: child)
                    rankUserList.append(rankuser)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rankusers"), object: self, userInfo: ["rankusers":rankUserList])
            }
        })
        
        //rankUserList를 Rankviewcontroller로 보내준다.
        //사진은 어떻게 할지는 있다가.
    }
    
    
    //For mainPage/////////////////////////////////////
    func loadProfileimg(uid: String, imgview: UIImageView, ranklabel: UILabel){
        print("loadProfileimg called")
        self.ref = Database.database().reference().child("users").child(uid)
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.value as? NSDictionary{
                let profileimg = result["profileImg"] as? String ?? " "
                let rankname = result["rankName"] as? String ?? " "
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileimg"), object: nil, userInfo: ["profileimg": profileimg, "imgview":imgview, "ranklabel":ranklabel, "rankname": rankname])
                }
        })
    }
    
    //For mainPage///////////////////////////////////
    func loadMainFeed(){
        User.users = [User]()
        self.ref = Database.database().reference().child("posts")
        self.ref.queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for child in result {
                    let user = User(snapshot: child)
                    User.users.append(user)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "users2"), object: self)
            }
        })
    }
    
    
    //For my Page ////////////////////////////////
    func loadPersonalFeed(username: String){
        User.myUsers = [User]()
        self.ref = Database.database().reference().child("posts")
        self.ref.queryOrdered(byChild: "author").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                let sort = result.sorted(by:{ $1.childSnapshot(forPath: "time").value as! Int > $0.childSnapshot(forPath: "time").value as! Int})
                for child in sort {
                    let user = User(snapshot: child)
                    User.myUsers.append(user)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "users3"), object: self)
                
            }
            
        })
    }
    
    func likeRequest(postId:String){
        ref = Database.database().reference()
        let key = ref.child("likeRequest").childByAutoId().key
        //print(key)
        let post = ["postId": postId ,"result": ["count":0,"state":"default"],"uid": Auth.auth().currentUser?.uid] as [String : Any]
        let childUpdates = ["/likeRequest/\(key)": post]
        ref.updateChildValues(childUpdates)
        print("")
    }
    
    //좋아요 버튼 초기 상태. 눌려있는지 아닌지.
    func setFirstImage(postkey: String, uid: String, button: LikeButton) {
        var check = false
        self.ref = Database.database().reference().child("postLikes").child(postkey)
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.value as? NSDictionary{
                let userList = result["userList"] as? [String] ?? [String]()
                if userList.contains(uid){
                    check = true
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likestatus"), object: nil, userInfo: ["doeslike": check, "button":button])
            }
        })
    }
    
    //좋아요 숫자.
    func setNum(postkey:String, label: UILabel, button: LikeButton){
        self.ref = Database.database().reference().child("postLikes").child(postkey)
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.value as? NSDictionary{
                let num = result["likes"] as? Int ?? 0
                //print(num)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likenum"), object: nil, userInfo: ["label": label, "button":button, "num":"\(num)"])
            }
        })
    }
    func loadProfileImageFromUsers(){
        
        if AuthModel.isLoginStatus(){
            self.ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let profileImg = value?["profileImg"] as? String ?? ""
                print("did\(profileImg)")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReturnProfileImageURL"), object: self,userInfo: ["profileImageUrl":profileImg])
                // ...
            }) { (error) in
                
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    
    func loadUserInfo(pageCase: Int)
    {
        
        if AuthModel.isLoginStatus(){
           
            print("loadUserInfo")
            self.ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                User.currentLoginedUserNickName = value?["username"] as! String
                User.currentLoginedUserRankName = value?["rankName"] as! String
                User.currentLoginedUserLikes = value?["likes"] as! Int
                User.currentLoginedUserSayHi = value?["sayhi"] as! String
                self.downloadprofileimage(name: value?["profileImg"] as! String)
                
                if pageCase == 1{
                    //글쓰기
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadUserInfo1"), object: self)
                }
                else if pageCase == 2{
                    
                    //마이페이지
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadUserInfo2"), object: self)
                    print("noticall")
                }
                
                
                // ...
            }) { (error) in
                
                print(error.localizedDescription)
            }
        }
    }
    
    
    func downloadprofileimage(name: String){
        Storage.storage().reference(withPath: "profileImages/" + name).downloadURL { (url, error) in
            User.imageview.kf.setImage(with: url)
        }
    }

}
