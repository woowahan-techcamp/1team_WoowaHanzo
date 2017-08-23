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
            for index in 0...list.count-1{
                self.addUser(user: list[index], index: index)
            }
        }
        
    }
    
    func addUser(user: User, index: Int){
        
        //height를 최종적으로 결정해주어도 괜찮다.
        
        
        
        
        //image는 어떻게 할지 나중에. ! 미리 다운받아놓을 수 있도록...
        
        
        var inypos = 10
        
        
        let cellview = UIView()
        cellview.layer.borderColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0).cgColor
        cellview.layer.borderWidth = 1
        
        //높이: 기본값으로 둘 수 있을 것이다. 나중에 max등으로 비교해서 적용하도록.
        cellview.frame = CGRect(x: 0, y: ypos + 10, width : Int(self.frame.width), height: 80)
        self.addSubview(cellview)
        
        let profileimgview = UIImageView()
        profileimgview.frame = CGRect(x:10, y:inypos, width: 60, height: 60)
        profileimgview.contentMode = UIViewContentMode.scaleAspectFill
        profileimgview.clipsToBounds = true //image set 전에 해주어야 한다.
        profileimgview.image = UIImage(named: "profile.png")
        profileimgview.layer.cornerRadius = profileimgview.frame.width / 2
        
        //사진 나중에 업데이트해주어야 함.
        //profimag!??
//        if user != nil {
//            Storage.storage().reference(withPath: "profileImages/" + user.profileImg!).downloadURL { (url, error) in
//                profileimgview.kf.setImage(with: url)
//                cellview.addSubview(profileimgview)
//            }
//        }
        
        cellview.addSubview(profileimgview)
        var lastview : UIView =  profileimgview
        inypos = inypos + Int(lastview.frame.size.height) + 10
        
        
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
        inypos = inypos + Int(lastview.frame.size.height) + 5
        
        let tagListView = TagPageView2(frame: CGRect(x: 0, y: inypos, width: Int(cellview.frame.width), height: 70))
        for i in user.tags!{
            tagListView.addTag(text: "#"+i, target: self, backgroundColor: UIColor.white, textColor: color)
        }
        tagListView.frame.size.height = tagListView.contentSize.height
        tagListView.layer.borderWidth = 0.5
        tagListView.layer.borderColor = UIColor.blue.cgColor
        cellview.addSubview(tagListView)
        lastview = tagListView
        inypos = inypos + Int(lastview.frame.size.height) + 10

        
        let scrollview = UIScrollView()
        let imgsize = 120
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
                    //fill을 안하면 Horizontal scroll이 가능하다!
                    imageview.clipsToBounds = true
                    imageview.kf.setImage(with: url)
                    //images.append(imageview)
                    imageview.frame = CGRect(x:10 + index * (imgsize + 10), y:0, width: imgsize, height: imgsize)
                    imageview.layer.cornerRadius = 3
                    

                    scrollview.addSubview(imageview)
                    scrollview.contentSize = CGSize(width: max(Int(scrollview.frame.width + 1),Int(10 + user.imageArray!.count * (imgsize + 25))), height: imgsize)
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

        let likebutton = LikeButton()
        //피드에 따라 기본 그림이 달라져야 한다. 나중에 설정해주기.
        likebutton.whenButtonTouched(postkey: user.key)
        likebutton.frame = CGRect(x: 20, y: inypos, width: 30, height: 30)
        cellview.addSubview(likebutton)
        lastview = likebutton
        inypos = inypos + Int(lastview.frame.size.height) + 10
        
        
        
        
        
        
        
        cellview.frame.size.height = CGFloat(inypos)
        ypos = ypos + Int(cellview.frame.size.height) + 10
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
}
