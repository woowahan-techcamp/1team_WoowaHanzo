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
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
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
           
            if let tagArray = User.users[indexPath.section].tagsArray
            {
                cell.tagLabel.text = "#\(tagArray[indexPath.row])"
            }
            return cell
        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//   {
////        let collectionViewWidth = self.collectionView.bounds.size.width
////        cell.frame.size.width = collectionViewWidth
////        cell.locationLabel.frame.size.width = collectionViewWidth
//
//       return CGSize(width: (User.users[indexPath.section].tagsArray?[indexPath.row]., height: 100)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        if indexPath.item % 3 == 0 {
//            let cellWidth = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right))
//            return CGSize(width: cellWidth, height: cellWidth / 2)
//        } else {
//            let cellWidth = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right) - flowLayout.minimumInteritemSpacing) / 2
//            return CGSize(width: cellWidth, height: cellWidth)
//        }
//        
//    }
    
}

