//
//  MainPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    

}
extension MainPageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainPageTableViewCell
        return cell
    }
    
}
