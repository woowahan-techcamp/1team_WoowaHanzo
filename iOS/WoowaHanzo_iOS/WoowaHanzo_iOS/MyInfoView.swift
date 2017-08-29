//
//  MyInfoView.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 29..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import UIKit
class MyInfoView : UIView{
    
    var profileImageView: UIImageView = UIImageView()
    var nickNameLabel:UILabel = UILabel()
    var sayHiLabel:UILabel = UILabel()
    var postNumLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        
         profileImageView.image = UIImage(named: "profile.png")
        profileImageView.frame = CGRect(x: 147, y: 37, width: 120, height: 120)
        nickNameLabel.frame = CGRect(x: 147, y: 167, width: 120, height: 21)
         sayHiLabel.frame = CGRect(x: 186  , y: 190, width: 42, height: 22)
         postNumLabel.frame = CGRect(x: 162 , y: 213, width: 90 , height: 21)
        nickNameLabel.font = UIFont(name: "NotoSans", size: 15.0)!
        sayHiLabel.font = UIFont(name: "NotoSans", size: 12.0)!
        sayHiLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        
        postNumLabel.font = UIFont(name: "NotoSans-Bold", size: 17.0)!
       
        self.backgroundColor = UIColor.white
        self.addSubview(profileImageView)
        self.addSubview(nickNameLabel)
        self.addSubview(sayHiLabel)
        self.addSubview(postNumLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func awakeFromNib() {
//        profileImageView.image = UIImage(named: "profile.png")
//        profileImageView.frame = CGRect(x: 147, y: 37, width: 120, height: 120)
//        nickNameLabel.frame = CGRect(x: 147, y: 167, width: 120, height: 21)
//        sayHiLabel.frame = CGRect(x: 186  , y: 148, width: 42, height: 22)
//        postNumLabel.frame = CGRect(x: 162 , y: 213, width: 90 , height: 21)
//        nickNameLabel.font = UIFont(name: "NotoSans", size: 14.0)!
//        sayHiLabel.font = UIFont(name: "NotoSans", size: 12.0)!
//        sayHiLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
//        postNumLabel.font = UIFont(name: "NotoSans-Bold", size: 17.0)!
//        self.addSubview(profileImageView)
//        self.addSubview(nickNameLabel)
//        self.addSubview(sayHiLabel)
//        self.addSubview(postNumLabel)
//    }
    
}
