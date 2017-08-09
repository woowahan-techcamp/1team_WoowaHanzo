//
//  MainPageTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit


class MainPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mainpageCollectionView: UICollectionView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nickNameButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "reload"), object: nil)
        mainpageCollectionView.dataSource = self
        mainpageCollectionView.delegate = self
        mainpageCollectionView.reloadData()
        if let flowLayout = mainpageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(
                width: 50, height: mainpageCollectionView.bounds.size.height)
        }
        //        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        //        let screenWidth = UIScreen.main.bounds.size.width
        // self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // Initialization code
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func reloadCollectionView(){
        print("dd")
        mainpageCollectionView.reloadData()
        print(User.users[0].tagsArray)
        
    }
    
}
extension MainPageTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    //MARK: CollectionView extension
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (User.users[section].tagsArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainPageCollectionViewCell
        cell.tagLabel.layer.cornerRadius = 10
        cell.tagLabel.layer.masksToBounds = true
        
        cell.tagLabel.preferredMaxLayoutWidth = cell.tagLabel.frame.width
        //            cell.contentView.bounds = cell.bounds
        //            cell.layoutIfNeeded()
        
        

        if let tagArray = User.users[indexPath.section].tagsArray
        {
            cell.tagLabel.text = "#\(tagArray[indexPath.row])"
        }
        return cell
    }
    
    
    
    
}
