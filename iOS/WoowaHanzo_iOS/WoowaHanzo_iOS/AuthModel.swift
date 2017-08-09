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
    static func login(){
        
    }
    static func register(){
        //있는 닉네임인지 체크.
        
    }
    func validPassword(pwText: String)->Bool{
        if pwText.length() < 7 { return false }
        else{ return true }
    }
    func logout(){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
}
