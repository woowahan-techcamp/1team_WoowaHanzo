//
//  TagPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import Firebase

class TagPageViewController: UIViewController {
    
    var tagListView:TagPageView!
    var ref: DatabaseReference!
    var key : String = ""
    var shouldalert = false
    var tagName:String = ""
    var tagResultArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(getTagResult(_ :)), name: NSNotification.Name(rawValue: "tagResult"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(escapealert), name: NSNotification.Name(rawValue: "escape"), object: nil)
        
        let color = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        
        tagListView = TagPageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(tagListView)
        tagListView.backgroundColor = UIColor.white
        tagListView.layer.borderColor = UIColor.white.cgColor
        tagListView.layer.borderWidth = 1.5
        
        var Tags = [String]()
        self.ref = Database.database().reference().child("tags")
        let refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! [String : AnyObject]
            if let result = snapshot.children.allObjects as? [DataSnapshot]{
                for index in result{
                    Tags.append(index.key as! String)
                }
                for i in Tags {
                    self.tagListView.addTag(text: "#"+i, target: self, backgroundColor: UIColor.white, textColor: color)
                }
                
            }
            else{
                self.tagListView.addTag(text:"태그를 추가해주세요.", target: self, backgroundColor: UIColor.white, textColor: color)
            }
        })
        alert()
        
    }
    override func viewWillAppear(_ animated: Bool){
        alert()
    }
    
    
    func escapealert(){
        self.shouldalert = true
        
    }
    
    func alert(){
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
    func handleTap(sender: UITapGestureRecognizer) {
        if let a = (sender.view as? UILabel)?.text {
            tagName = a
            print("A")
            FirebaseModel().tagQuery(tagName: tagName)
            performSegue(withIdentifier: "ShowTagResult", sender: self)
        }
        else { return }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTagResult" {
            if let viewController = segue.destination as? TagResultTableViewController {
                viewController.tagName = tagName
                
            }
        }
    }
    func getTagResult(_ notification: Notification){
        
        tagResultArray = []
        self.ref = Database.database().reference().child("tagQuery")
        let refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as! [String : AnyObject]
            if let result = snapshot.childSnapshot(forPath: notification.userInfo?["key"] as! String).childSnapshot(forPath: "queryResult").value {
                self.tagResultArray = []
                if let tagResult = result as? [Any]
                {
                    for index in tagResult{
                        self.tagResultArray.append(index)
                    }
                }
                //print(self.tagResultArray)
                
            }
            if self.tagResultArray.count > 1{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendResultViewController"), object: self, userInfo: ["tagResultArray": self.tagResultArray] )
            }
        })
        
    }
    //    func tap(sender:UIGestureRecognizer)
    //    {
    //        let label = (sender.view as! UILabel)
    //        print("tap from \(label.text!)")
    //    }
    //    func longPress(sender:UIGestureRecognizer)
    //    {
    //        let label = (sender.view as! UILabel)
    //        print("long press from \(label.text!)")
    //    }
        
    @IBAction func tagButtonTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchPage", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "searchView")
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
