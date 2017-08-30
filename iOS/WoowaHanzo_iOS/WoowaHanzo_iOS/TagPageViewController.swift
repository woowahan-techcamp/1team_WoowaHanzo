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
    var tagResultArray : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getTagResult(_ :)), name: NSNotification.Name(rawValue: "tagResult"), object: nil)
        self.title = "태그"
        let color = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        
        tagListView = TagPageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(tagListView)
        tagListView.backgroundColor = UIColor.white
        tagListView.layer.borderColor = UIColor.white.cgColor
        tagListView.layer.borderWidth = 1.5
        
        var Tags = [String]()
        self.ref = Database.database().reference().child("tagCounter")
        ref.observe(DataEventType.value, with: { (snapshot) in
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
        
        
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        NotificationCenter.default.removeObserver(self)
//    }
    
    
    func handleTap(sender: UITapGestureRecognizer) {
        if let a = (sender.view as? UILabel)?.text {
            tagName = a
            //print("A")
            FirebaseModel().tagQuery(tagName: tagName)
            performSegue(withIdentifier: "ShowTagResult", sender: self)
        }
        else { return }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTagResult" {
            if let viewController = segue.destination as? TagResultViewController {
                viewController.tagName = tagName
            }
        }
    }
    
    
    //MARK:firebase에서 보내는 노티(tagResult)를 받아 실행 될 함수
    func getTagResult(_ notification: Notification){
        
        //해당 태그가 있는 posts의 아이디를 담을 배열
        tagResultArray = []
        self.ref = Database.database().reference().child("tagQuery")
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.hasChildren(){
                if let result = snapshot.childSnapshot(forPath: notification.userInfo?["key"] as! String).childSnapshot(forPath: "queryResult").value {
                    self.tagResultArray = []
                    //print(result as? [String])//print(self.tagResultArray)
                    self.tagResultArray = result as? [String]
                    //print(self.tagResultArray)
                }
                
                if (self.tagResultArray?.count ?? 0) > 1 {
                    //TagResultViewController로 노티를 보낸다.
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendResultViewController"), object: self, userInfo: ["tagResultArray": self.tagResultArray])
                }
            }
            })
    }
  
    
}
