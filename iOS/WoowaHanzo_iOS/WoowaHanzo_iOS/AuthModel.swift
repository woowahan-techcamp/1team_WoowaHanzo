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
    static func register(){
        
        
    }

    func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
}
