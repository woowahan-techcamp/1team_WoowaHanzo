//
//  MainPageTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FTImageViewer

class MainPageTableViewCell: UITableViewCell {
    
    var userid : Int = 0
    //@IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    //@IBOutlet weak var mainpageCollectionView: UICollectionView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var FoodImageCollectionView: UICollectionView!
    //@IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nickNameButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsTextView.layoutIfNeeded()
        FoodImageCollectionView.delegate = self
        FoodImageCollectionView.dataSource = self
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
        profileImageView.clipsToBounds = true
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func likeButtonTouched(_ sender: Any) {
        
        if let image = likeButton.currentImage, image == #imageLiteral(resourceName: "emptyHeard") {
            likeButton.setImage(#imageLiteral(resourceName: "emptyheart"), for: .normal)
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "emptyHeard"), for: .normal)
            
        }
    }
    
}

extension MainPageTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
       // print(User.users[items].imageArray?.count)
        return User.users[userid].imageArray?.count ?? 1//이부분 모르겠음
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoodImageCollectionViewCell
  
        if let imageArray = User.users[userid].imageArray{
            print(User.users[userid])
                print("A")
                let ref = Storage.storage().reference(withPath: imageArray[indexPath.row]).downloadURL { (url, error) in
                    //print(imageArray)
                    cell.foodImageView.kf.setImage(with: url)
                    print(url)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
}



