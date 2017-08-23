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
        print("posting: \(assets.count) \(names.count)")
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
    
    func tagQuery(tagName:String){
        
        ref = Database.database().reference()
        let key = ref.child("tagQuery").childByAutoId().key
        //print(key)
        let post = ["queryResult": "1" ,"tag": tagName] as [String : String]
        let childUpdates = ["/tagQuery/\(key)": post]
        ref.updateChildValues(childUpdates)
        print("send tag result")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tagResult"), object: self, userInfo: ["key":key])
        
    }
    
    func loadFeed(){
        
        self.ref = Database.database().reference().child("posts")
        
        self.ref.queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                User.users = [User]()
                for child in result {
                    //print(child)
                    var userKey = child.key as! String
                    //print(child.childSnapshot(forPath: "author").value!)
                    let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tags: child.childSnapshot(forPath: "tags").value as? [String] ?? nil,imageArray:child.childSnapshot(forPath: "images").value as? [String] ?? nil, postDate : child.childSnapshot(forPath: "time").value as! Int, uid: child.childSnapshot(forPath: "uid").value as! String)
                    User.users.append(user)
                    
                    
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                }
                
                
                
            }
        })
        
        
    }
    //    func loadFeedTag(){
    //
    //        self.ref = Database.database().reference().child("posts")
    //
    //        self.ref.queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let result = snapshot.children.allObjects as? [DataSnapshot]{
    //                User.users = [User]()
    //                for child in result {
    //                    //print(child)
    //                    var userKey = child.key as! String
    //                    //print(child.childSnapshot(forPath: "author").value!)
    //                    let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tags: child.childSnapshot(forPath: "tags").value as? [String] ?? nil,imageArray:child.childSnapshot(forPath: "images").value as? [String] ?? nil, postDate : child.childSnapshot(forPath: "time").value as! Int)
    //                    User.users.append(user)
    //
    //
    //                    //태그!!
    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tagResult"), object: nil)
    //                }
    //
    //
    //
    //            }
    //        })
    
    
    //    }
    
    //    func loadTagFeed(){
    //        self.ref = Database.database().reference().child("posts")
    //
    //        self.ref.queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let result = snapshot.children.allObjects as? [DataSnapshot]{
    //                User.users = [User]()
    //                for child in result {
    //                    //print(child)
    //                    var userKey = child.key as! String
    //                    //print(child.childSnapshot(forPath: "author").value!)
    //                    let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tags: child.childSnapshot(forPath: "tags").value as? [String] ?? nil,imageArray:child.childSnapshot(forPath: "images").value as? [String] ?? nil, postDate : child.childSnapshot(forPath: "time").value as! Int)
    //                    User.users.append(user)
    //
    //
    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    //                }
    //
    //
    //
    //            }
    //        })
    //
    //
    //    }
    
    
    
//For RankPage////////////////////////////////////
    func loadUsers(){
        print("loadUsers called")
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
    func loadProfileimg(uid: String, imgview: UIImageView){
        print("loadProfileimg called")
        self.ref = Database.database().reference().child("users").child(uid)
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.value as? NSDictionary{
                let profileimg = result["profileImg"] as? String ?? nil
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileimg"), object: nil, userInfo: ["profileimg": profileimg, "imgview":imgview])

            }
        })
    }
    
//For mainPage///////////////////////////////////
    func loadUsers2(){
        print("loadUsers2 called")
        User.users = [User]()
        self.ref = Database.database().reference().child("posts")
        //나중에 Likes가 확보되면  likes로 바꾸기.
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
    func likeRequest(postId:String){
            ref = Database.database().reference()
            let key = ref.child("likeRequest").childByAutoId().key
            //print(key)
            let post = ["postId": postId ,"result": ["count":0,"state":"default"],"uid": Auth.auth().currentUser?.uid] as [String : Any]
            let childUpdates = ["/likeRequest/\(key)": post]
            ref.updateChildValues(childUpdates)
            print("")
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tagResult"), object: self, userInfo: ["key":key])
        }
    
    
    func loadProfileImageFromUsers(){

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
