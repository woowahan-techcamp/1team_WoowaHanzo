//
//  UserListView.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserListView: UIScrollView {
    var numberOfRows = 0
    var currentRow = 0
    var tags = [UILabel]()
    var containerView:UIView!
    var rowHeight : CGFloat = 100
    var xoffset = 0
    var yoffset = 100
    var ypos = 100
    
    
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        numberOfRows = Int(frame.height / rowHeight)
        containerView = UIView(frame: self.frame)
        self.addSubview(containerView)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    override func awakeFromNib() {
        numberOfRows = Int(self.frame.height / rowHeight)
        containerView = UIView(frame: self.frame)
        self.addSubview(containerView)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addUserList(users: [User]?){
        if let list = users {
            for index in 0...list.count-1{
                self.addUser(user: list[index], index: index)
            }
        }
        
    }
    
    func addUser(user: User, index: Int){
        
        //height를 최종적으로 결정해주어도 괜찮다.
        
        
        
        
        //image는 어떻게 할지 나중에. ! 미리 다운받아놓을 수 있도록...
        
        let cellview = UIView()
        cellview.layer.borderColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0).cgColor
        cellview.layer.borderWidth = 1
        
        //높이: 기본값으로 둘 수 있을 것이다. 나중에 max등으로 비교해서 적용하도록.
        cellview.frame = CGRect(x: 0, y: ypos + 10, width : Int(self.frame.width), height: 80)
        self.addSubview(cellview)
        
        let profileimgview = UIImageView()
        profileimgview.image = UIImage(named: "profile.png")
        profileimgview.frame = CGRect(x:10, y:10, width: 60, height: 60)
        profileimgview.clipsToBounds = true
        profileimgview.layer.cornerRadius = profileimgview.frame.width / 2
        
        
        //profimag!??
        if user != nil {
            Storage.storage().reference(withPath: "profileImages/" + user.profileImg!).downloadURL { (url, error) in
                profileimgview.kf.setImage(with: url)
                cellview.addSubview(profileimgview)
            }
        }
        
        cellview.addSubview(profileimgview)
        
        
        let textview = UITextView()
        textview.text = user.contents
        textview.font = UIFont(name: "NotoSans", size: 17.0)!
        textview.sizeToFit()
        textview.frame.origin = CGPoint(x:0, y:0)
        cellview.addSubview(textview)
        
        
        
        cellview.frame.size.height = textview.frame.size.height
        ypos = ypos + Int(textview.frame.size.height) + 10
        self.contentSize = CGSize(width: Int(self.frame.width), height: yoffset + ypos)
        
//        let numlabel = UILabel()
//        numlabel.text = "\(index + 1)"
//        numlabel.textAlignment = NSTextAlignment.center
//        numlabel.font = UIFont(name: "NotoSansUI", size: 25.0)!
//        numlabel.frame = CGRect(x: xoffset, y: ypos, width: 66, height: 80)
//        
//        self.addSubview(numlabel)
//        let profileimgview = UIImageView()
//        profileimgview.image = UIImage(named: "profile.png")
//        profileimgview.frame = CGRect(x:10, y:10, width: 60, height: 60)
//        profileimgview.clipsToBounds = true
//        profileimgview.layer.cornerRadius = profileimgview.frame.width / 2
//        
//        if rankuser.profileImg != nil {
//            Storage.storage().reference(withPath: "profileImages/" + rankuser.profileImg!).downloadURL { (url, error) in
//                profileimgview.kf.setImage(with: url)
//                cellview.addSubview(profileimgview)
//            }
//        }
//        
//        cellview.addSubview(profileimgview)
//        
//        
//        let namelabel = UILabel()
//        namelabel.text = rankuser.nickName
//        namelabel.textAlignment = NSTextAlignment.center
//        namelabel.font = UIFont(name: "NotoSans", size: 17.0)!
//        namelabel.textColor = UIColor.darkGray
//        namelabel.sizeToFit()
//        namelabel.frame.origin = CGPoint(x: 85, y: 37)
//        cellview.addSubview(namelabel)
//        
//        let ranknamelabel = UILabel()
//        ranknamelabel.text = rankuser.rankName!
//        ranknamelabel.textAlignment = NSTextAlignment.center
//        ranknamelabel.font = UIFont(name: "NotoSans-Bold", size: 18.0)!
//        ranknamelabel.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
//        ranknamelabel.sizeToFit()
//        ranknamelabel.frame.origin = CGPoint(x:85, y:15)
//        cellview.addSubview(ranknamelabel)
//        
//        
//        let likenumlabel = UILabel()
//        likenumlabel.text = String(describing: rankuser.likes!)
//        likenumlabel.textAlignment = NSTextAlignment.center
//        likenumlabel.font = UIFont(name: "NotoSansUI", size: 17.0)!
//        likenumlabel.sizeToFit()
//        likenumlabel.frame.origin = CGPoint(x:260-likenumlabel.frame.width, y : 30)
//        cellview.addSubview(likenumlabel)
//        
//        let heartimgview = UIImageView()
//        heartimgview.image = #imageLiteral(resourceName: "emptyheart")
//        heartimgview.sizeToFit()
//        heartimgview.frame.origin = CGPoint(x:260, y:30)
//        cellview.addSubview(heartimgview)
        
        
    }
    
    func addTag(text:String, target:AnyObject, backgroundColor:UIColor,textColor:UIColor)
    {
        //instantiate label
        //you can customize your label here! but make sure everything fit. Default row height is 30.
        let label = UILabel()
        label.clipsToBounds = true
        label.backgroundColor = backgroundColor
        label.text = text
        label.textColor = textColor
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        label.layer.cornerRadius = 10
        label.layer.borderColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0).cgColor
        label.layer.borderWidth = 1.5
        let tapGesture = UITapGestureRecognizer(target: target, action: #selector(TagPageViewController.handleTap))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        self.tags.append(label)
        
        //calculate frame
        //        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y , width: label.frame.width + tagCombinedMargin, height: rowHeight - tagVerticalPadding)
        //        if self.tags.count == 0
        //        {
        //            label.frame = CGRect(x: hashtagsOffset.left, y: hashtagsOffset.top, width: label.frame.width, height: label.frame.height)
        //            self.addSubview(label)
        //        }
        //        else
        //        {
        //            label.frame = self.generateFrameAtIndex(index: tags.count-1, rowNumber: &currentRow)
        //            self.addSubview(label)
        //        }
    }
    
    
    
}
