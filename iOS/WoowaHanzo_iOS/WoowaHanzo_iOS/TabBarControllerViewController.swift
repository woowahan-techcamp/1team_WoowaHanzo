//
//  TabBarControllerViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var shouldalert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(escapealert), name: NSNotification.Name(rawValue: "escape"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(escapefalse), name: NSNotification.Name(rawValue: "escapefalse"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    func escapealert(){
        //should not dispatchqueue here.
        //dispatchqueue makes it called later
        self.shouldalert = true
        //print("espcapetrue")
    }
    func escapefalse(){
        self.shouldalert = false
        //print("escapefalse")
    }
    
    func alert(slower: Bool){
        var time = DispatchTime.now()
        if slower {
            time = DispatchTime.now() + 1.5
        }
        if shouldalert{
            let alert = UIAlertController(title: "글 작성이 완료되지 않았습니다.", message: "글 작성을 취소하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                DispatchQueue.main.async{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "escapecancel"), object: nil)
                //self.shouldloadview = false
                self.selectedIndex = 2
                }
            })
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                DispatchQueue.main.async{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "escapeOK"), object: nil)
                //self.shouldloadview = true
                }
            })
            DispatchQueue.main.asyncAfter(deadline: time) {
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selected = item.title!
        if selected == "홈" || selected == "마이페이지" {
            DispatchQueue.main.async{
            self.alert(slower: true)
            }
            
        }
        else if selected == "태그" || selected == "랭킹"{
            DispatchQueue.main.async{
                self.alert(slower: false)
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
