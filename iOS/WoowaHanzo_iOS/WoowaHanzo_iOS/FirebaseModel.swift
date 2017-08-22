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
                    let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tags: child.childSnapshot(forPath: "tags").value as? [String] ?? nil,imageArray:child.childSnapshot(forPath: "images").value as? [String] ?? nil, postDate : child.childSnapshot(forPath: "time").value as! Int)
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
        

    }
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

