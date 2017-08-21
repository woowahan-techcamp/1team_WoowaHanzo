//
//  TagResultTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class TagResultTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tagResultTimeLabel: UILabel!
    @IBOutlet weak var tagResultNickNameLabel: UILabel!
    @IBOutlet weak var tagResultLikeButton: UIButton!
    @IBOutlet weak var tagResultFoodCollectionView: UICollectionView!
    @IBOutlet weak var tagResultTagView: UIView!
    @IBOutlet weak var tagResultImageView: UIImageView!
    @IBOutlet weak var tagResultTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
