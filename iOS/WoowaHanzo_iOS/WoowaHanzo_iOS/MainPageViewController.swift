//
//  MainPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class MainPageViewController: UIViewController,NVActivityIndicatorViewable{
    
    var firebaseModel = FirebaseModel()
    var searchBar = UISearchBar()


    @IBOutlet weak var mainpageTableView: UITableView!
    @IBOutlet weak var searchIconButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //firebase에서 loadFeed하는것에 옵저버를 걸어준다.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        
        mainpageTableView.delegate = self
        mainpageTableView.dataSource = self

        searchBar.alpha = 0
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        
    }
    
    func reloadTableData(){
        mainpageTableView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        firebaseModel.loadFeed()
        searchIconButton.tintColor = UIColor.white
        let size = CGSize(width: 30, height: 30)
        
        startAnimating(size, message: "Loading...", type: .ballTrianglePath)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopAnimating()
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    @IBAction func searchIconTouched(_ sender: Any) {
        
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
        UIView.animate(withDuration: 2, animations: {
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
   


}

