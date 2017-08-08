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
        mainpageTableView.delegate = self
        mainpageTableView.dataSource = self
        firebaseModel.loadFeed()
        mainpageTableView.reloadData()
    }

    

}
extension MainPageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainPageTableViewCell
        cell.contentsTextView.text = "dd"
        return cell
    }
    
}
