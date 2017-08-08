//
//  LoginModel.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import Firebase
class LoginModel{

    static func isLoginStatus()->Bool{
        if Auth.auth().currentUser != nil{
            return true
        }
        else{
            return false
        }
    }
    
}
