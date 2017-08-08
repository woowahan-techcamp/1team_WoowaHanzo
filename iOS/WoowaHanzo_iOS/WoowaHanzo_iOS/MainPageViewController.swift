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
        DispatchQueue.global().async{
            self.firebaseModel.loadFeed()
            DispatchQueue.main.async {
                self.mainpageTableView.reloadData()
            }
            
        }
        mainpageTableView.delegate = self
        mainpageTableView.dataSource = self
        DispatchQueue.main.async {
            self.mainpageTableView.reloadData()
        }
        
        
        
    }
    
    func reloadTableData()
    {
        mainpageTableView.reloadData()
        print("Dd")
    }

    
}
extension MainPageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return User.users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!MainPageTableViewCell
        cell.contentsTextView.text = User.users[indexPath.row].contents
        
        return cell
    }
    
}
