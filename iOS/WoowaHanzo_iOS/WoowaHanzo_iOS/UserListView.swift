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
    var containerView:UIView!
    var rowHeight : CGFloat = 100
    var xoffset = 0
    var yoffset = 100
    var ypos = 58
    let color = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    
    
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        containerView = UIView(frame: self.frame)
        containerView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        self.addSubview(containerView)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    override func awakeFromNib() {
        containerView = UIView(frame: self.frame)
        containerView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        self.addSubview(containerView)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addUserList(users: [User]?){
        
        if let list = users {
            if list.count > 0 {
                for index in 0...list.count-1{
                    self.addUser(user: list[index], index: index)
                }
            }
        }
        
    }
    
    func addUser(user: User, index: Int){
        var inypos = 10
        var inxpos = 20
        
        
        let cellview = UIView()
        cellview.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        cellview.layer.borderWidth = 1
        cellview.backgroundColor = UIColor.white
        
        //높이: 기본값으로 둘 수 있을 것이다. 나중에 max등으로 비교해서 적용하도록.
        cellview.frame = CGRect(x: 0, y: ypos + 10, width : Int(self.frame.width), height: 80)
        self.addSubview(cellview)
        
        
        
        //profile image, rank name label, name label //////////////////////////////
        let profileimgview = UIImageView()
        profileimgview.frame = CGRect(x:inxpos, y:inypos + 20, width: 40, height: 40)
        profileimgview.contentMode = UIViewContentMode.scaleAspectFill
        profileimgview.clipsToBounds = true //image set 전에 해주어야 한다.
        profileimgview.image = UIImage(named: "profile.png")
        profileimgview.layer.cornerRadius = profileimgview.frame.width / 2
        
        ///ranknamelabel
        let ranknamelabel = UILabel()
        ranknamelabel.font = UIFont(name:"NotoSans-Bold", size: 14.0)
        ranknamelabel.textColor = UIColor.lightGray
        ranknamelabel.frame.origin = CGPoint(x:70, y: inypos + 43)
        cellview.addSubview(ranknamelabel)
        
        FirebaseModel().loadProfileimg(uid: user.uid, imgview: profileimgview, ranklabel: ranknamelabel)
        //rankname도 같이 가져온다.
        //completion handler를 써도 된다.
        //img download 하고 notification을 통해 설정해준다. 아래의 updateprofileimg가 호출됨.
        cellview.addSubview(profileimgview)
        
        ///namelabel
        let namelabel = NickNameLabel()
        namelabel.whenLabelTouchedOnMainPage()
        namelabel.text = user.nickName
        namelabel.font = UIFont(name: "NotoSans-Bold", size: 17.0)!
        namelabel.sizeToFit()
        namelabel.frame.origin = CGPoint(x: 70, y: inypos + 17)
        cellview.addSubview(namelabel)
        
        var lastview : UIView =  profileimgview
        inypos = Int(lastview.frame.origin.y) + Int(lastview.frame.size.height) + 10
        
        
        //textview///////////////////////////////////////
        let textview = UITextView()
        textview.text = user.contents
        textview.font = UIFont(name: "NotoSans", size: 16.0)!
        textview.frame.origin = CGPoint(x:inxpos - 3, y:inypos)
        textview.frame.size = CGSize(width: Int(self.frame.width) - inxpos * 2 + 6, height: 30)
        let contentSize = textview.sizeThatFits(textview.bounds.size)
        var frame = textview.frame
        frame.size.height = max(contentSize.height, 30)
        textview.frame = frame
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: textview, attribute: .height, relatedBy: .equal, toItem: textview, attribute: .width, multiplier: textview.bounds.height/textview.bounds.width, constant: 1)
        textview.addConstraint(aspectRatioTextViewConstraint)
        textview.isScrollEnabled = false
        textview.isEditable = false
        cellview.addSubview(textview)
        lastview = textview
        inypos = Int(lastview.frame.origin.y) + Int(lastview.frame.size.height) + 0
        
        //tagListview//////////////////////////////////////
        let tagListView = TagPageView2(frame: CGRect(x: inxpos - 10, y: inypos, width: Int(cellview.frame.width), height: 70)) // taglistview2 파일에 있다.
        if let tags = user.tags{
            for i in tags{
                tagListView.addTag(text: "#"+i, target: self, backgroundColor: UIColor.white, textColor: color)
            }
            if tags.count > 0 {
                tagListView.frame.size.height = max(tagListView.contentSize.height, 40)
            }
            else{
                tagListView.frame.size.height = 0
            }
            cellview.addSubview(tagListView)
            lastview = tagListView
            inypos = inypos + Int(lastview.frame.size.height) + 0
            
            
        }
        
        //scrollview///////////////////////////////////////
        let scrollview = UIScrollView()
        let imgsize = 110
        scrollview.frame = CGRect(x: 10, y: inypos, width: Int(cellview.frame.width) - 20, height: imgsize)
        scrollview.showsHorizontalScrollIndicator = false
        let scrollcontainerView = UIView(frame: scrollview.frame)
        scrollview.addSubview(scrollcontainerView)
        if let usersImageArray = user.imageArray{
            print(user.imageArray)
            if user.imageArray! != [] {
                if user.imageArray!.count > 0 {
                    for index in 0...user.imageArray!.count - 1{
                        let name : String = user.imageArray![index]
                        let imageview = UIImageView()
                        Storage.storage().reference(withPath: "images/" + name).downloadURL { (url, error) in
                            imageview.contentMode = UIViewContentMode.scaleAspectFill
                            imageview.clipsToBounds = true
                            imageview.kf.setImage(with: url)
                            imageview.frame = CGRect(x:10 + index * (imgsize + 13), y:0, width: imgsize, height: imgsize)
                            imageview.layer.cornerRadius = 3
                            
                            
                            scrollview.addSubview(imageview)
                            scrollview.contentSize = CGSize(width: max(Int(scrollview.frame.width + 1),Int(10 + user.imageArray!.count * (imgsize + 13))), height: imgsize)
                            //contentsize를 크게 줘야 bouncing이 항상 가능하다.
                            cellview.addSubview(scrollview)
                        }
                    }
                }
            }
            else{
                scrollview.frame.size.height = 0
            }
            cellview.addSubview(scrollview)
            lastview = scrollview
            inypos = inypos + Int(lastview.frame.size.height) + 10
            //horizontal bar///////////////////////////////////////////////////
            let horizontalbar = UIView()
            horizontalbar.frame = CGRect(x:20, y: inypos, width: Int(cellview.frame.width) - inxpos * 2, height: 1)
            horizontalbar.backgroundColor = UIColor(red:240/255, green:240/255,blue:240/255, alpha: 1.0)
            cellview.addSubview(horizontalbar)
            lastview = horizontalbar
            inypos = inypos + Int(lastview.frame.size.height) + 8
            
            
            
            
            //likenumlabel and likebutton ////////////////////////////////////////////////////
            let likenumLabel = UILabel()
            let likebutton = LikeButton()
            
            likenumLabel.text = ""
            likenumLabel.font = UIFont(name:"NotoSansUI", size: 14.0)
            likenumLabel.frame.origin = CGPoint(x: 53, y:inypos + 4)
            cellview.addSubview(likenumLabel)
            
            FirebaseModel().setNum(postkey:user.key, label: likenumLabel, button: likebutton)
            
            //likebutton///////////////////////////////////////////////////////
            likebutton.whenButtonTouched(postkey: user.key, label:likenumLabel)
            FirebaseModel().setFirstImage(postkey:user.key, uid:AuthModel().returnUsersUid(), button: likebutton)
            
            
            likebutton.frame = CGRect(x: 20, y: inypos, width: 30, height: 30)
            cellview.addSubview(likebutton)
            lastview = likebutton
            
            
            
            //timelabel////////////////////////////////////////////////////////
            let timelabel = UILabel()
            timelabel.text = String(describing: Date().postTimeDisplay(timestamp: user.postDate))
            timelabel.font = UIFont(name:"NotoSansUI", size: 14.0)
            timelabel.textColor = UIColor.lightGray
            timelabel.sizeToFit()
            timelabel.frame.origin = CGPoint(x: Int(cellview.frame.width - timelabel.frame.width) - inxpos, y: inypos + 5)
            cellview.addSubview(timelabel)
            inypos = inypos + Int(lastview.frame.size.height) + 10 //lastview: likebutton
            
            cellview.frame.size.height = CGFloat(inypos)
            ypos = ypos + Int(cellview.frame.size.height) + 7 // 다음 cellview의 위치를 지정해준다.
            self.contentSize = CGSize(width: Int(self.frame.width), height: max(yoffset + ypos - 35, Int(self.frame.height + 1)))
        }
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if let a = (sender.view as? UILabel)?.text {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showTagResultPageFromMain"), object: self,userInfo:["tagName":a])
        }
        else { return }
        
    }
}
