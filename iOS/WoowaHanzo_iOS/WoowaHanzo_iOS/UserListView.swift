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
    var ypos = 58
    let color = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    
    
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)

        numberOfRows = Int(frame.height / rowHeight)
        containerView = UIView(frame: self.frame)
        containerView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        self.addSubview(containerView)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    override func awakeFromNib() {
        numberOfRows = Int(self.frame.height / rowHeight)
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
        
        //height를 최종적으로 결정해주어도 괜찮다.
        
        //addsubview는 한번만 해주면된다.
        
        
        
        
        //image는 어떻게 할지 나중에. ! 미리 다운받아놓을 수 있도록...
        
        
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
        let namelabel = UILabel()
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
        for i in user.tags!{
            tagListView.addTag(text: "#"+i, target: self, backgroundColor: UIColor.white, textColor: color)
        }
        if user.tags!.count > 0 {
        tagListView.frame.size.height = max(tagListView.contentSize.height, 40)
        }
        else{
            tagListView.frame.size.height = 0
        }
        cellview.addSubview(tagListView)
        lastview = tagListView
        inypos = inypos + Int(lastview.frame.size.height) + 0
        

//scrollview///////////////////////////////////////
        let scrollview = UIScrollView()
        let imgsize = 115
        scrollview.frame = CGRect(x: 10, y: inypos, width: Int(cellview.frame.width) - 20, height: imgsize)
        scrollview.showsHorizontalScrollIndicator = false
        let scrollcontainerView = UIView(frame: scrollview.frame)
        scrollview.addSubview(scrollcontainerView)
        
        if user.imageArray! != [] {
            if user.imageArray!.count > 0 {
            for index in 0...user.imageArray!.count - 1{
                let name : String = user.imageArray![index]
                let imageview = UIImageView()
                Storage.storage().reference(withPath: "images/" + name).downloadURL { (url, error) in
                    imageview.contentMode = UIViewContentMode.scaleAspectFill
                    imageview.clipsToBounds = true
                    imageview.kf.setImage(with: url)
                    imageview.frame = CGRect(x:inxpos + index * (imgsize + 13), y:0, width: imgsize, height: imgsize)
                    imageview.layer.cornerRadius = 3
                    

                    scrollview.addSubview(imageview)
                    scrollview.contentSize = CGSize(width: max(Int(scrollview.frame.width + 1),Int(inxpos + user.imageArray!.count * (imgsize + 13))), height: imgsize)
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


//likebutton///////////////////////////////////////////////////////
        let likebutton = LikeButton()
        likebutton.whenButtonTouched(postkey: user.key)
        //피드에 따라 기본 그림이 달라져야 한다. 나중에 설정해주기.
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
        ypos = ypos + Int(cellview.frame.size.height) + 7
        self.contentSize = CGSize(width: Int(self.frame.width), height: max(yoffset + ypos, Int(self.frame.height + 1)))
    }
    func updateProfileImg(_ notification: Notification){
        let profileimg = notification.userInfo?["profileimg"] as? String ?? nil
        let cellview = notification.userInfo?["cellview"] as? UIView ?? nil
        let imageview = notification.userInfo?["imgview"] as? UIImageView ?? nil
        print(profileimg)
        if cellview != nil && profileimg != nil && imageview != nil {
            Storage.storage().reference(withPath: "profileImages/" + profileimg!).downloadURL { (url, error) in
                imageview?.kf.setImage(with: url)
                cellview?.addSubview(imageview!)
                self.addSubview(cellview!)
            }
        }
    }
}
