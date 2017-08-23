
//  MainPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FTImageViewer
import Firebase

class MainPageViewController: UIViewController,NVActivityIndicatorViewable{
    
    var firebaseModel = FirebaseModel()
    var searchBar = UISearchBar()
    let cellSpacingHeight: CGFloat = 15
  
    @IBOutlet weak var dummyTextView: UITextView!
    @IBOutlet weak var dummyTagView: TagListView!
    var foodArray = [UIImage]()
    
    var userListView : UserListView!
    
    


    @IBOutlet weak var mainpageTableView: UITableView!
    @IBOutlet weak var searchIconButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "users2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileImg), name: NSNotification.Name(rawValue: "profileimg"), object: nil)
    
        searchBar.alpha = 0
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        
        userListView = UserListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        FirebaseModel().loadUsers2()
        self.view.addSubview(userListView)
        
    }
    //나중에 completion handler 로 바꿔보자.
    func updateProfileImg(_ notification: Notification){
        print("called////")
        let profileimg = notification.userInfo?["profileimg"] as? String ?? nil
        let imageview = notification.userInfo?["imgview"] as? UIImageView ?? nil
        if profileimg != nil && imageview != nil {
            Storage.storage().reference(withPath: "profileImages/" + profileimg!).downloadURL { (url, error) in
                imageview?.kf.setImage(with: url)
            }
        }
    }
    
  
   
    func viewload(_ notification: Notification){
        //let userlist = notification.userInfo?["users"] as? [User] ?? [User]()
        //print("\(userlist.count)개의 피드 데이터가 존재합니다.")
        userListView.addUserList(users: User.users)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let size = CGSize(width: 30, height: 30)

        DispatchQueue.main.async {
            self.startAnimating(size, message: "Loading...", type: .ballTrianglePath)
            self.firebaseModel.loadFeed()
        }

        
        dummyTextView.isScrollEnabled = false
        searchIconButton.tintColor = UIColor.black
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
            self.mainpageTableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
            
        }

    }
    
    //스크롤하면 키보드가 사라진다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
   
    @IBAction func searchIconTouched(_ sender: Any) {
        
        if navigationItem.titleView != nil{
            navigationItem.titleView = nil
            searchIconButton.title = ""
            searchIconButton.image = #imageLiteral(resourceName: "searchIcon")
            
            
        }else{
            searchIconButton.image = nil
            searchIconButton.title = "취소"
            showSearchBar()
        }
    }
    
    func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        //navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 2, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    func tap(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("tap from \(label.text!)")
    }
    
    
    
    @IBAction func showGalleryImageViewer(_ sender: Any) {
        
    }
    
}




////MARK: TableView extension
//extension MainPageViewController : UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return User.users.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//       
//        
//        print(User.users[indexPath.section].key)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!MainPageTableViewCell
//        cell.contentsTextView.text = User.users[indexPath.section].contents
//        cell.contentsTextView.sizeToFit()
//        cell.nickNameButton.setTitle(User.users[indexPath.section].nickName, for: .normal)
//        
//        cell.tagListView.reset()
//        cell.userid = indexPath.section
//        if let tag = User.users[indexPath.section].tags{
//            for index in tag{
//                cell.tagListView.addTag("#"+index, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: UIColor.white,textColor: UIColor.gray)
//            }
//        }
//        cell.tagListView.sizeToFit()
//        cell.timeLabel.text = String(describing: Date().postTimeDisplay(timestamp: User.users[indexPath.section].postDate))
//        DispatchQueue.main.async {
//            cell.FoodImageCollectionView.reloadData()
//
//        }
//        cell.userid = indexPath.section
//        
//        var frame = cell.tagListView.frame
//        frame.origin.y = cell.contentsTextView.frame.origin.y + cell.contentsTextView.frame.height + 10
//        cell.tagListView.frame = frame
//        
//        var frame2 = cell.FoodImageCollectionView.frame
//        frame2.origin.y = cell.tagListView.frame.origin.y +  cell.tagListView.frame.height + 10
//        cell.FoodImageCollectionView.frame = frame2
////        cell.tagArrayHeight.constant = self.dummyTagView.frame.size.height
////        cell.textViewHeight.constant = self.dummyTextView.frame.size.height
//        return cell
//    }
//    
////    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
////        
////        return UITableViewAutomaticDimension
////    }
//    
//   
//    //padding between cell
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
//    
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
////        
////        let myCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainPageTableViewCell
//////        let heightForCell = myCell.contentsTextView.frame.height + myCell.tagListView.frame.height +  myCell.FoodImageCollectionView.frame.height
//////        //let h = myCell.contentsTextView.contentSize.height + myCell.tagListView.contentSize.height + myCell.FoodImageCollectionView.contentSize.height
//////        //print()
//////        let height = myCell.contentsTextViewConstraint.constant + myCell.tagListView.bounds.height + myCell.FoodImageCollectionView.bounds.height
//////
//////        return height
////        var height: CGFloat = 0.0
////        self.dummyTextView.text = User.users[indexPath.section].contents
////       
////       // let fixedWidth = self.dummyUserTextView?.frame.size.width
////
////        self.dummyTextView.sizeToFit()
////        //print(dummyTextView?.frame.size.height)
////        if let tag = User.users[indexPath.section].tags{
////            for index in tag{
////                self.dummyTagView?.addTag("#"+index, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: UIColor.white,textColor: UIColor.gray)
////            }
////        }
////        
////        self.dummyTagView?.sizeToFit()
////        //print("dd\(dummyTagView.frame.size.height)")
//////        if let imageArray = User.users[indexPath.row].imageArray{
//////            height += 120
//////        }
////      
////        height += dummyTextView.frame.size.height + dummyTagView.frame.size.height + 200
////        return height
////    }
////   
////    
////}

//}

