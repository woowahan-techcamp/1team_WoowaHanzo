//
//  MyPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase


class MyPageViewController: UIViewController {
    var shouldalert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(escapealert), name: NSNotification.Name(rawValue: "escape"), object: nil)
        UINavigationBar.appearance().backgroundColor = UIColor.white

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
            self.present(controller, animated: false, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !AuthModel.isLoginStatus(){
            
            var alert = UIAlertController(title: "로그인 후 이용하실 수 있습니다. ", message: "로그인 하시겠습니까?", preferredStyle: .alert)
            var cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
                self.present(controller, animated: false, completion: nil)
                //self.navigationController?.pushViewController(controller, animated: true)
                //self.show(controller, sender: self)
            })
            var ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginNavigation")
                //self.present(controller, animated: true, completion: nil)
                //self.navigationController?.pushViewController(controller, animated: true)
                self.show(controller, sender: self)
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else{
            //로그인이 되었다면? 내 마이페이지를 보여줘야함. 
        }
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
        }


    }
    func escapealert(){
        self.shouldalert = true
        
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
