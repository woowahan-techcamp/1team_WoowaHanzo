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
    var tagName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
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

        
    }
    

    
        func handleTap(sender: UITapGestureRecognizer) {
            if let a = (sender.view as? UILabel)?.text {
    
                tagName = a
                ////여기서 검색기능수행하면 됨!
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
