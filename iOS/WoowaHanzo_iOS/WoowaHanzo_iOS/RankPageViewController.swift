//
//  RankPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class RankPageViewController: UIViewController {
    var rankListView : RankListView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(viewload), name: NSNotification.Name(rawValue: "rankusers"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nickNameLabelTouched(_ :)), name: NSNotification.Name(rawValue: "NickNameLableTouched"), object: nil)
        rankListView = RankListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        FirebaseModel().loadUsers()
        self.view.addSubview(rankListView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewload(_ notification: Notification){
        let rankuserlist = notification.userInfo?["rankusers"] as? [RankUser] ?? [RankUser]()
        print("\(rankuserlist.count)개의 랭크 데이터가 존재합니다.")
        rankListView.addRankUserList(rankusers: rankuserlist)
    }
    
    func nickNameLabelTouched(_ notification:Notification){
        
        User.currentUserName = notification.userInfo?["NickNameLabel"] as! String
        
        print("nickNameLabelTouched")
        
        let storyboard = UIStoryboard(name: "NickNameClickResult", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NickNameClickResultViewController")
        FirebaseModel().ReturnNickNameClickResult()
        self.show(controller, sender: self)
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
