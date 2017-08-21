//
//  TagResultTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class TagResultTableViewCell: UITableViewCell {

    @IBOutlet weak var tagResultNickNameLabel: UILabel!
    @IBOutlet weak var tagResultImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
