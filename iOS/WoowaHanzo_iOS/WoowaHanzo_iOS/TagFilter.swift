//
//  TagFilter.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation

class TagFilter{
    
    //영문 소문자, 대문자, 숫자 허용.
    //언더바: 95, &:38,
    //한글: 44032 ~55203(음절)
    //12593~12643(한글알파벳)
    func isValid(_ id: String) -> Bool{
        for i in id.characters{
            let num = UnicodeScalar(String(i))!.value
            if !((num>=65 && num<=90) || (num>=97 && num<=122) || (num>=48 && num<=57)) { return false }
        }
        return true
    }
    func isValid2(_ id: String) -> Bool{
        for i in id.characters{
            let num = UnicodeScalar(String(i))!.value
            if !((num>=44032 && num<=55203) || (num>=12593 && num<=12643) || num==95) { return false }
        }
        return true
    }
    func isValid3(_ id: String) -> Bool{
        for i in id.characters{
            let num = UnicodeScalar(String(i))!.value
            if ((num>=123 && num<=127) || (num>=91 && num<=94) || num==96 || (num>=58 && num<=63) || (num>=32 && num<=47)) { return false }
        }
        return true
    }
    func isValid4(_ id: String) -> Bool{
        if id[0] != "#"{
            return false
        }
        for i in id[1..<id.characters.count].characters{
            let num = UnicodeScalar(String(i))!.value
            if ((num>=123 && num<=127) || (num>=91 && num<=94) || num==96 || (num>=58 && num<=63) || (num>=32 && num<=47)) { return false }
        }
        return true
    }

    

}
