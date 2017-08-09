//
//  MainPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var mainpageTableView: UITableView!
    var firebaseModel = FirebaseModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "reload"), object: nil)
        self.firebaseModel.loadFeed()
        mainpageTableView.delegate = self
        mainpageTableView.dataSource = self
        
    }
    
    func reloadTableData(){
        mainpageTableView.reloadData()
    }

    @IBAction func searchIconTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchPage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "searchView")
        //self.present(controller, animated: true, completion: nil)
        //self.navigationController?.pushViewController(controller, animated: true)
        self.show(controller, sender: self)
    }
    
}

//MARK: TableView extension
extension MainPageViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return User.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!MainPageTableViewCell
        cell.contentsTextView.text = User.users[indexPath.row].contents
        cell.nickNameButton.setTitle(User.users[indexPath.row].nickName, for: .normal)
        return cell
    }
    
}

