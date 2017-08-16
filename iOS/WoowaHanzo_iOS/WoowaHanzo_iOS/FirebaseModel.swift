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
    
    func postReview(review: String, userID: String, tagArray:[String], timestamp: Int, images:[String],postDate:String){
        ref = Database.database().reference()
        let key = ref.child("posts").childByAutoId().key
        let post = ["author":userID,
                    "body": review,
                    "tagArray": tagArray,
                    "timestamp": timestamp,"imageArray":images,
                    "postDate":postDate] as [String : Any]
        let childUpdates = ["/posts/\(key)": post]
        ref.updateChildValues(childUpdates)
    }
    
    func postImages(assets:[PHAsset]){
        for i in 0..<assets.count{
            let asset = assets[i]
            let image = self.getAssetThumbnail(asset: asset)
            DispatchQueue.global().async{
                //if let imageData = UIImageJPEGRepresentation(image, 0.8){
                if let imageData = UIImagePNGRepresentation(image){
                    let ref = Storage.storage().reference(withPath: "images/\(Date().timeIntervalSince1970)").putData(imageData)
                    ref.resume()
                    print("success: \(i) ")
                }
                else{
                    print(image.size)
                }
            }
        }
    }
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        // for testing
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            //manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    
    
    func loadFeed(){
        
        self.ref = Database.database().reference().child("posts")
        
        self.ref.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                User.users = [User]()
                for child in result {
                    print(child)
                    var userKey = child.key as! String
                    //print(child.childSnapshot(forPath: "author").value!)
                    let user = User(key: userKey, nickName: child.childSnapshot(forPath: "author").value as! String, contents: child.childSnapshot(forPath: "body").value as! String,tagsArray: child.childSnapshot(forPath: "tagArray").value as? [String] ?? nil,imageArray:child.childSnapshot(forPath: "imageArray").value as? [String] ?? nil,postDate : child.childSnapshot(forPath: "postDate").value as! String)
                        User.users.append(user)
                    
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                }
                
                
                
            }
        })
        
            
    }
}
