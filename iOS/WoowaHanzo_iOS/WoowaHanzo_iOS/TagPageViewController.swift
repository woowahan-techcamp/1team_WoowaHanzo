//
//  TagPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit

class TagPageViewController: UIViewController {

    var tagListView:TagListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        
        tagListView = TagListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(tagListView)
        tagListView.backgroundColor = UIColor.white
        tagListView.layer.borderColor = UIColor.white.cgColor
        tagListView.layer.borderWidth = 1.5
        
        let demoTags = ["friends","fashion","smile","like4like","instamood","family","nofilter","amazing","style","follow4follow","tbt","tflers","beach","followforfollow","lol","yolo","hair","iphoneonly","cool","girls","webstgram","funny","iphonesia","tweegram","my","instacool","igdaily","makeup","instagramhub","awesome","bored","instafollow","nice","eyes","look","throwback","look","home","instacollage"]
        for i in demoTags {
            tagListView.addTag("#"+i, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: UIColor.white,textColor: color)
        }
    }
    
    @IBAction func deleteMultipleTags(sender: AnyObject) {
        tagListView.removeMultipleTagsWithIndices([0,3,6,1,2,3,4,5,6,7,9,10,11])
    }
    
    @IBAction func deleteFirstTag(sender: AnyObject) {
        tagListView.removeTagWithIndex(0)
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func addTag(sender: AnyObject) {
        if textField.text != nil
        {
            tagListView.addTag(textField.text!, target: self, tapAction: nil, longPressAction: nil, backgroundColor: UIColor.black, textColor: UIColor.white)
        }
        self.textField.resignFirstResponder()
        
    }
    func tap(sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("tap from \(label.text!)")
    }
    func longPress(sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("long press from \(label.text!)")
    }
    
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
