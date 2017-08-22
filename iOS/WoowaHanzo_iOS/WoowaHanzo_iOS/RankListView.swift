//
//  RankListView.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import Foundation
import UIKit

class RankListView: UIScrollView {
    var numberOfRows = 0
    var currentRow = 0
    var tags = [UILabel]()
    var containerView:UIView!
    var rowHeight : CGFloat = 80
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
            for index in 0...list.count-1{
                self.addRankUser(rankuser: list[index], index: index)
            }
        }
        
    }
    
    func addRankUser(rankuser: RankUser, index: Int){
        let ypos = yoffset + Int(rowHeight) * index
        
        let numlabel = UILabel()
        numlabel.text = "\(index + 1)"
        numlabel.textAlignment = NSTextAlignment.center
        numlabel.font = UIFont(name: "NotoSansUI", size: 25.0)!
        //calculate frame
        numlabel.frame = CGRect(x: xoffset, y: ypos, width: 40, height: 80)
        
        self.addSubview(numlabel)
        
        //image는 어떻게 할지 나중에.
        
        let cellview = UIView()
        cellview.layer.cornerRadius = 10
        cellview.layer.borderColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0).cgColor
        cellview.layer.borderWidth = 1.5
        cellview.frame = CGRect(x: 66, y: ypos + 10, width : 301, height: 60)
        self.addSubview(cellview)
        
        
        
        let namelabel = UILabel()
        namelabel.text = rankuser.nickName
        namelabel.textAlignment = NSTextAlignment.center
        namelabel.font = UIFont(name: "NotoSans", size: 17.0)!
        namelabel.textColor = UIColor.darkGray
        namelabel.sizeToFit()
        //let frame = CGRect(x: 200, y: ypos + 30, width: namelabel.frame.width, height: namelabel.frame.height)
        namelabel.frame.origin = CGPoint(x: 22, y: 20)
        cellview.addSubview(namelabel)
        
        
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
