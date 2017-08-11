//
//  MainPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController,UISearchBarDelegate{
    
    
    @IBOutlet weak var mainpageTableView: UITableView!
    var firebaseModel = FirebaseModel()
    
    
    @IBOutlet weak var searchIconButton: UIBarButtonItem!
    var searchBar = UISearchBar()
    override func viewDidLoad() {
                //mainpageTableView.rowHeight =
        //mainpageTableView.rowHeight = UITableViewAutomaticDimension
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "reload"), object: nil)
        self.firebaseModel.loadFeed()
        mainpageTableView.delegate = self
        mainpageTableView.dataSource = self
//        mainpageTableView.rowHeight = UITableViewAutomaticDimension
//        mainpageTableView.estimatedRowHeight = 400
        searchBar.delegate = self
        searchBar.alpha = 0
        searchBar.searchBarStyle = UISearchBarStyle.minimal
    }
    
    func reloadTableData(){
        mainpageTableView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        firebaseModel.loadFeed()
    }

   
    @IBAction func searchIconTouched(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "SearchPage", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "searchView")
//        //self.present(controller, animated: true, completion: nil)
//        //self.navigationController?.pushViewController(controller, animated: true)
//        self.show(controller, sender: self)
        if navigationItem.titleView != nil{
            navigationItem.titleView = nil
             searchIconButton.title = "검색"
            
        }else{
            searchIconButton.title = "취소"
        showSearchBar()
        }
    }
    func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        //navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 0, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    
}

//MARK: TableView extension
extension MainPageViewController : UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return User.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!MainPageTableViewCell
        cell.contentsTextView.text = User.users[indexPath.row].contents
        cell.nickNameButton.setTitle(User.users[indexPath.row].nickName, for: .normal)
        //print(User.users[indexPath.row].tagsArray)
        
        if let tagArr = User.users[indexPath.row].tagsArray{
            cell.tags.tags = tagArr

        }else{
            cell.tags.tags = nil
        }
        //tableView.estimatedRowHeight = 336
        //tableView.rowHeight = UITableViewAutomaticDimension

        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.contentSize.height 
    }


}

