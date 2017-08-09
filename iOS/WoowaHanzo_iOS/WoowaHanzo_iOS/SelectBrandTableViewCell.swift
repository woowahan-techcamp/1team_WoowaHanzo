//
//  SelectBrandTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class SelectBrandTableViewCell: UITableViewCell {

    @IBOutlet weak var brandMenuNumLabel: UILabel!
    
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandLogoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
