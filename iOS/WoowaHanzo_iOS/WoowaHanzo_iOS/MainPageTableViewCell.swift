//
//  MainPageTableViewCell.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import UITags


class MainPageTableViewCell: UITableViewCell,UITagsViewDelegate {
    
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    //@IBOutlet weak var mainpageCollectionView: UICollectionView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nickNameButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tags: UITags!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tags.delegate = self
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
        
        
        reviewView.layer.borderWidth = 1.0
        reviewView.layer.borderColor = UIColor.gray.cgColor
        reviewView.layer.cornerRadius = 30.0
        reviewView.clipsToBounds = true
//        tagTextView.resolveHashTags()
//        tagTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.blue]
//        tagTextView.isScrollEnabled = false
//        tagTextView.delegate = self
        
 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func tagSelected(atIndex index:Int) -> Void {
        print("Tag at index:\(index) selected")
    }
    
    func tagDeselected(atIndex index:Int) -> Void {
        print("Tag at index:\(index) deselected")
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
extension MainPageTableViewCell : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let URL = url.scheme {
            let arrId = Int(URL)
            print(hashtagArr?[arrId!])
            
//            let alertController = UIAlertController(title: "AZHashtagTextViewExample", message: "\(hashtagArr![arrId!])", preferredStyle: .alert)
//            let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//                alertController.dismiss(animated: true, completion: nil)
//            }
//            alertController.addAction(okBtn)
//            
            //self.present(alertController, animated: true, completion: nil)
            
        }
        return false
    }
}


