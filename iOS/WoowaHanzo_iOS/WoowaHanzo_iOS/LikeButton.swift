//
//  LikeButton.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class LikeButton: UIButton {
    var postkey : String = ""
    func whenButtonTouched(postkey: String) {
        self.postkey = postkey
        self.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
    }
    func buttonTouched(){
        if let image = self.currentImage, image == #imageLiteral(resourceName: "emptyHeard") {
            self.setImage(#imageLiteral(resourceName: "emptyheart"), for: .normal)
        } else {
            self.setImage(#imageLiteral(resourceName: "emptyHeard"), for: .normal)
            
        }
        print("\(postkey) - pressed")
    //postkey에 맞는 likerequest function 보내주어야 함.
    }

}
