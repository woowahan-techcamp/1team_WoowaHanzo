//
//  SearchViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y:0, width: 500, height:40))
        searchBar.placeholder = "Search for Places"
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}