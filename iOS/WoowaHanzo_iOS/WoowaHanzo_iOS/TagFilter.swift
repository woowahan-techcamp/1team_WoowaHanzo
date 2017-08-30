//
//  TagFilter.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation

class TagFilter{
    
    func isValid(_ id: String) -> Bool{
        if id.characters.count == 0{
            return true
        }
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
