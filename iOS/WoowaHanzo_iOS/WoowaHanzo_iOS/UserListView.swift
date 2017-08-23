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
    let color = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    
    
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
        
        
        let cellview = UIView()
        cellview.layer.borderColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0).cgColor
        cellview.layer.borderWidth = 1
        
        //높이: 기본값으로 둘 수 있을 것이다. 나중에 max등으로 비교해서 적용하도록.
        cellview.frame = CGRect(x: 0, y: ypos + 10, width : Int(self.frame.width), height: 80)
        self.addSubview(cellview)
        
        
        
//profile image//////////////////////////////
        let profileimgview = UIImageView()
        profileimgview.frame = CGRect(x:10, y:inypos, width: 60, height: 60)
        profileimgview.contentMode = UIViewContentMode.scaleAspectFill
        profileimgview.clipsToBounds = true //image set 전에 해주어야 한다.
        profileimgview.image = UIImage(named: "profile.png")
        profileimgview.layer.cornerRadius = profileimgview.frame.width / 2
        
        print("helloe")
        FirebaseModel().loadProfileimg(uid: user.uid, imgview: profileimgview)
        //completion handler를 써도 된다.
        //img download 하고 notification을 통해 설정해준다. 아래의 updateprofileimg가 호출됨.
        
        
        cellview.addSubview(profileimgview)
        var lastview : UIView =  profileimgview
        inypos = inypos + Int(lastview.frame.size.height) + 10
        
//textview///////////////////////////////////////
        let textview = UITextView()
        textview.text = user.contents
        textview.font = UIFont(name: "NotoSans", size: 16.0)!
        textview.frame.origin = CGPoint(x:8, y:inypos)
        textview.frame.size = CGSize(width: self.frame.width - 16, height: 70)
        let contentSize = textview.sizeThatFits(textview.bounds.size)
        var frame = textview.frame
        frame.size.height = max(contentSize.height, 70)
        textview.frame = frame
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: textview, attribute: .height, relatedBy: .equal, toItem: textview, attribute: .width, multiplier: textview.bounds.height/textview.bounds.width, constant: 1)
        textview.addConstraint(aspectRatioTextViewConstraint)
        
        textview.isScrollEnabled = false
        textview.isEditable = false
        cellview.addSubview(textview)
        lastview = textview
        inypos = inypos + Int(lastview.frame.size.height) + 0
        
//tagListview//////////////////////////////////////
        let tagListView = TagPageView2(frame: CGRect(x: 0, y: inypos, width: Int(cellview.frame.width), height: 70))
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
        scrollview.frame = CGRect(x: 0, y: inypos, width: Int(cellview.frame.width), height: imgsize)
        scrollview.showsHorizontalScrollIndicator = false
        let scrollcontainerView = UIView(frame: scrollview.frame)
        scrollview.addSubview(scrollcontainerView)
        
        if user.imageArray! != [] {
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
        else{
            scrollview.frame.size.height = 0
        }
        cellview.addSubview(scrollview)
        lastview = scrollview
        inypos = inypos + Int(lastview.frame.size.height) + 10

//likebutton///////////////////////////////////////////////////////
        let likebutton = LikeButton()
        likebutton.whenButtonTouched(postkey: user.key)
        //피드에 따라 기본 그림이 달라져야 한다. 나중에 설정해주기.
        likebutton.frame = CGRect(x: 20, y: inypos, width: 30, height: 30)
        cellview.addSubview(likebutton)
        lastview = likebutton
        inypos = inypos + Int(lastview.frame.size.height) + 10
        
        
        
        
        
        
        
        
        cellview.frame.size.height = CGFloat(inypos)
        ypos = ypos + Int(cellview.frame.size.height) + 10
        self.contentSize = CGSize(width: Int(self.frame.width), height: yoffset + ypos)
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
