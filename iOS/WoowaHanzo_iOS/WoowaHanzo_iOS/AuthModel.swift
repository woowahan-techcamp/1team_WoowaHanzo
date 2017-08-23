//
//  LoginModel.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import Firebase

class AuthModel{

    static func isLoginStatus()->Bool{
        if Auth.auth().currentUser != nil{
            return true
        }
        else{
            return false
        }
    }
    
    static func login(email:String,pw:String, completion: @escaping (Bool)->()){
        Auth.auth().signIn(withEmail: email, password: pw) { (user, error) in
            if user != nil{
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    static func register(email:String,pw:String,completion : @escaping (Bool)->()){
        Auth.auth().createUser(withEmail: email, password: pw) { (user, error) in
            if user != nil{
                completion(true)
            }
            else{
                completion(false)
            }
       }
    }
    static func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    static func isValidpassword(pw:String)-> Bool{
        if pw.characters.count >= 6{
            return true
        }
        else {
            return false
        }
    }
    
    static func saveUser(email:String,profileImg:String?,UserSayText: String?,nickName:String){
        if let user = Auth.auth().currentUser{
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let key = ref.child("users").child(user.uid).key
            let post = ["email":email,"profileImg": "4aMeLLBXrqdvMsyYU6gShXRZYPq2.jpeg","sayhi": UserSayText, "username":nickName,"likes":0, "rankName" :"평민"] as [String : Any]
            let childUpdates = ["/users/\(key)": post]
            UserDefaults.standard.set(nickName, forKey: "userNickName")
            ref.updateChildValues(childUpdates)

        }
    }
  
    
    
}
