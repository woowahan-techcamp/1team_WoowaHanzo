//
//  TagResultTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class TagResultTableViewCell: UITableViewCell {
    
    var userid : Int = 0
    @IBOutlet weak var tagResultTimeLabel: UILabel!
    @IBOutlet weak var tagResultNickNameLabel: UILabel!
    @IBOutlet weak var tagResultLikeButton: UIButton!
    @IBOutlet weak var tagResultFoodCollectionView: UICollectionView!
    @IBOutlet weak var tagResultTagView: TagListView!
    @IBOutlet weak var tagResultImageView: UIImageView!
    @IBOutlet weak var tagResultTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tagResultFoodCollectionView.delegate = self
        tagResultFoodCollectionView.dataSource = self
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension TagResultTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("A")
        if let count = User.tagUsers[userid].imageArray?.count{
            print(count)
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodImagCell", for: indexPath) as! TagResultCollectionViewCell
        print(User.tagUsers[userid].imageArray?.count)
        if let imageArray = User.tagUsers[userid].imageArray{
            //print(User.users[userid])
            //print("A")
            let ref = Storage.storage().reference(withPath: "images/" + imageArray[indexPath.row]).downloadURL { (url, error) in
                cell.TagResultFoodImage.kf.setImage(with: url)
                //cell.foodImageView.layer.cornerRadius = 3.0
                //print(url)
            }
        }
        
        // print(imageArr)
        //        cell.foodImageView.image = imageArr[indexPath.item]
        //
        return cell
    }
}
