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
    var label : UILabel = UILabel()
    var num : Int = 0
    func whenButtonTouched(postkey: String, label: UILabel) {
        self.postkey = postkey
        self.label = label
        self.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
    }
    func buttonTouched(){
        if let image = self.currentImage, image == #imageLiteral(resourceName: "emptyHeard") {
            self.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            self.label.text = "\(num + 1)"
        } else {
            self.setImage(#imageLiteral(resourceName: "emptyHeard"), for: .normal)
            self.label.text = "\(num - 1)"
        }
    FirebaseModel().likeRequest(postId: postkey)
        print("\(postkey) - pressed")
    //postkey에 맞는 likerequest function 보내주어야 함.
    }
    

}
