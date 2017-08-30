//
//  RankListView.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RankListView: UIScrollView {
    var numberOfRows = 0
    var currentRow = 0
    var tags = [UILabel]()
    var containerView:UIView!
    var rowHeight : CGFloat = 100
    var xoffset = 0
    var yoffset = 20
    
    
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
    
    func addRankUserList(rankusers: [RankUser]?){
        if let list = rankusers {
            if list.count > 0 {
            for index in 0...list.count-1{
                self.addRankUser(rankuser: list[index], index: index)
            }
            }
        }
        
    }
    
    func addRankUser(rankuser: RankUser, index: Int){
        let ypos = yoffset + Int(rowHeight) * index
        
        let numlabel = UILabel()
        numlabel.text = "\(index + 1)"
        numlabel.textAlignment = NSTextAlignment.center
        numlabel.font = UIFont(name: "NotoSansUI", size: 25.0)!
        numlabel.frame = CGRect(x: xoffset, y: ypos, width: Int(self.frame.width * 58 / 375), height: 80)
        
        self.addSubview(numlabel)
        
        //image는 어떻게 할지 나중에. ! 미리 다운받아놓을 수 있도록...
        
        let cellview = UIView()
        cellview.layer.cornerRadius = 15
        cellview.layer.borderColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0).cgColor
        cellview.layer.borderWidth = 1
        cellview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        let margin = Int(self.frame.width * 50 / 375)
        cellview.frame = CGRect(x: margin, y: ypos + 10, width : Int(self.frame.width) - (margin * 2) + 25, height: 80)
        self.addSubview(cellview)
        self.contentSize = CGSize(width: Int(self.frame.width), height: Int(rowHeight) * (index + 1) + yoffset + 10)
        
        
        let profileimgview = UIImageView()
        profileimgview.contentMode = UIViewContentMode.scaleAspectFill
        profileimgview.image = UIImage(named: "profile.png")
        profileimgview.frame = CGRect(x:10, y:10, width: 60, height: 60)
        profileimgview.clipsToBounds = true
        profileimgview.layer.cornerRadius = profileimgview.frame.width / 2
        
        if rankuser.profileImg != nil {
            Storage.storage().reference(withPath: "profileImages/" + rankuser.profileImg!).downloadURL { (url, error) in
                profileimgview.kf.setImage(with: url)
                cellview.addSubview(profileimgview)
            }
        }

        cellview.addSubview(profileimgview)
        
        
        let namelabel = NickNameLabel()
        namelabel.whenLabelTouchedOnRankPage()
        namelabel.text = rankuser.nickName
        namelabel.textAlignment = NSTextAlignment.left
        namelabel.font = UIFont(name: "NotoSans", size: 17.0)!
        namelabel.textColor = UIColor.darkGray
        namelabel.sizeToFit()
        namelabel.frame.size.height = namelabel.frame.size.height + 50
        namelabel.frame.size.width = namelabel.frame.size.width + 100
        namelabel.frame.origin = CGPoint(x: 85, y: 37-20)
        
        
        cellview.addSubview(namelabel)
        
        let ranknamelabel = UILabel()
        ranknamelabel.text = rankuser.rankName!
        ranknamelabel.textAlignment = NSTextAlignment.center
        ranknamelabel.font = UIFont(name: "NotoSans-Bold", size: 18.0)!
        ranknamelabel.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        ranknamelabel.sizeToFit()
        ranknamelabel.frame.origin = CGPoint(x:85, y:15)
        cellview.addSubview(ranknamelabel)
        
        let heartimgview = UIImageView()
        heartimgview.image = UIImage(named: "heartBlue_Final")
        heartimgview.sizeToFit()
        heartimgview.frame.origin = CGPoint(x:cellview.frame.width - heartimgview.frame.width - 20, y:30)
        cellview.addSubview(heartimgview)
        
        let likenumlabel = UILabel()
        likenumlabel.text = String(describing: rankuser.likes!)
        likenumlabel.textAlignment = NSTextAlignment.center
        likenumlabel.font = UIFont(name: "NotoSansUI", size: 14.0)!
        likenumlabel.textColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
        likenumlabel.sizeToFit()
        likenumlabel.frame.origin = CGPoint(x:heartimgview.frame.origin.x - likenumlabel.frame.width - 5, y : 30)
        cellview.addSubview(likenumlabel)
        
        
        
        
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
        

    }

    
    
}
