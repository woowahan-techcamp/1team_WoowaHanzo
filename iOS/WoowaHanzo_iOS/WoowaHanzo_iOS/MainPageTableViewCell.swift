//
//  MainPageTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit


class MainPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    //@IBOutlet weak var mainpageCollectionView: UICollectionView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var FoodImageCollectionView: UICollectionView!
    //@IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nickNameButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
        profileImageView.clipsToBounds = true
        //print(tags.collectionView?.contentSize.height)
        reviewView.layer.borderWidth = 1.0
        reviewView.layer.borderColor = UIColor.gray.cgColor
        reviewView.layer.cornerRadius = 30.0
        reviewView.clipsToBounds = true

        
 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    
    
}

