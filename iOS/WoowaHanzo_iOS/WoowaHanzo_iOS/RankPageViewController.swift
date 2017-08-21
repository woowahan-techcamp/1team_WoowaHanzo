//
//  RankPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class RankPageViewController: UIViewController {
    
    var shouldalert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(escapealert), name: NSNotification.Name(rawValue: "escape"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func escapealert(){
        self.shouldalert = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if shouldalert{
            let alert = UIAlertController(title: "글 작성이 완료되지 않았습니다.", message: "글 작성을 취소하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "escapecancel"), object: nil)
                //self.shouldloadview = false
                self.tabBarController?.selectedIndex = 2
            })
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "escapeOK"), object: nil)
                //self.shouldloadview = true
            })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
        }

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
