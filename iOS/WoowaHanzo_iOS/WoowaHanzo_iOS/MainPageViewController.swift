//
//  MainPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FTImageViewer

class MainPageViewController: UIViewController,NVActivityIndicatorViewable{
    
    var firebaseModel = FirebaseModel()
    var searchBar = UISearchBar()
    let cellSpacingHeight: CGFloat = 15
    var dummyUserTextView : UITextView?
    var dummyUserTagView: TagListView?
    var dummyUserCollectionView : UICollectionView?
    
    


    @IBOutlet weak var mainpageTableView: UITableView!
    @IBOutlet weak var searchIconButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        dummyUserTextView?.translatesAutoresizingMaskIntoConstraints = true
        dummyUserTextView?.isScrollEnabled = false
        mainpageTableView.keyboardDismissMode = .onDrag
        //firebase에서 loadFeed하는것에 옵저버를 걸어준다.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "reload"), object: nil)
        

        mainpageTableView.delegate = self
        mainpageTableView.dataSource = self

        searchBar.alpha = 0
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        mainpageTableView.reloadData()
       
        mainpageTableView.estimatedRowHeight = UITableViewAutomaticDimension
        //mainpageTableView.rowHeight = 488
    }
    
  
   
    func reloadTableData(){
        mainpageTableView.reloadData()
    

    }
    override func viewWillAppear(_ animated: Bool) {
        
        firebaseModel.loadFeed()
        searchIconButton.tintColor = UIColor.black
        let size = CGSize(width: 30, height: 30)
        
        startAnimating(size, message: "Loading...", type: .ballTrianglePath)
        
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

//MARK: TableView extension
extension MainPageViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return User.users.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!MainPageTableViewCell
        cell.contentsTextView.text = User.users[indexPath.section].contents
        cell.nickNameButton.setTitle(User.users[indexPath.section].nickName, for: .normal)
        cell.tagListView.reset()
        cell.userid = indexPath.section
        if let tag = User.users[indexPath.section].tagsArray{
            for index in tag{
                cell.tagListView.addTag("#"+index, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: UIColor.white,textColor: UIColor.gray)
            }
        }
        cell.timeLabel.text = Date().postTimeDisplay(postDate: User.users[indexPath.section].postDate)
        cell.FoodImageCollectionView.reloadData()
        //print(User.users[indexPath.section].imageArray)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
//        
//        return UITableViewAutomaticDimension
//    }
    
   
    //padding between cell
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
//        let myCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainPageTableViewCell
//        let heightForCell = myCell.contentsTextView.frame.height + myCell.tagListView.frame.height +  myCell.FoodImageCollectionView.frame.height
//        //let h = myCell.contentsTextView.contentSize.height + myCell.tagListView.contentSize.height + myCell.FoodImageCollectionView.contentSize.height
//        //print()
//        let height = myCell.contentsTextViewConstraint.constant + myCell.tagListView.bounds.height + myCell.FoodImageCollectionView.bounds.height
//
//        return height
        var height: CGFloat = 0.0
        self.dummyUserTextView?.text = User.users[indexPath.section].contents
       
        let fixedWidth = self.dummyUserTextView?.frame.size.width

        self.dummyUserTextView?.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat.greatestFiniteMagnitude))
        
        print(dummyUserTextView?.frame.size.height)
        if let tag = User.users[indexPath.section].tagsArray{
            for index in tag{
                self.dummyUserTagView?.addTag("#"+index, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: UIColor.white,textColor: UIColor.gray)
            }
        }
        self.dummyUserTagView?.sizeToFit()
        if let imageArray = User.users[indexPath.row].imageArray{
            height += 120
        }
        
        

        return height
    }
   
   
}


