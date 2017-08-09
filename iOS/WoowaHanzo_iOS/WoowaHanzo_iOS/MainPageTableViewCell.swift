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
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadCollectionView(){
        mainpageCollectionView.reloadData()
        print(User.users[0].tagsArray)
        print("dd")
    }

}
extension MainPageTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate{
    //MARK: CollectionView extension
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return (User.users[section].tagsArray?.count)!
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainPageCollectionViewCell
            cell.tagLabel.text = User.users[indexPath.section].tagsArray?[indexPath.row]
            return cell
        }
    
}

