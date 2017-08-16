//
//  MainPageTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import ImageViewer
import Kingfisher
import Firebase

extension UIImageView: DisplaceableView {}

struct DataItem {
    
    let imageView: UIImageView
    let galleryItem: GalleryItem
}

class MainPageTableViewCell: UITableViewCell {
    
    var items: [DataItem] = []
    @IBOutlet weak var reviewView: UIView!
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
        
        
        FoodImageCollectionView.delegate = self
        FoodImageCollectionView.dataSource = self
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
        profileImageView.clipsToBounds = true
        reviewView.layer.borderWidth = 1.0
        reviewView.layer.borderColor = UIColor.gray.cgColor
        reviewView.layer.cornerRadius = 30.0
        reviewView.clipsToBounds = true
        
 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
}

extension MainPageTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return User.users[section].imageArray?.count ?? 1//이부분 모르겠음
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoodImageCollectionViewCell
        let ref = Storage.storage().reference(withPath: "/images/bossam001.jpg").downloadURL { (url, error) in
            print(url)
            //self.imageView.sd_setImage(with: url, completed: nil)
            //self.cell.i.kf.setImage(with: url)
            cell.foodImageView.kf.setImage(with: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
}
extension MainPageTableViewCell: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        
        return index < items.count ? items[index].imageView : nil
    }
}

extension MainPageTableViewCell: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        
        return items[index].galleryItem
    }
}

extension MainPageTableViewCell: GalleryItemsDelegate {
    
    func removeGalleryItem(at index: Int) {
        
        print("remove item at \(index)")
        
        let imageView = items[index].imageView
        imageView.removeFromSuperview()
        items.remove(at: index)
    }
}

// Some external custom UIImageView we want to show in the gallery
class FLSomeAnimatedImage: UIImageView {
}

// Extend ImageBaseController so we get all the functionality for free
class AnimatedViewController: ItemBaseController<FLSomeAnimatedImage> {
}

