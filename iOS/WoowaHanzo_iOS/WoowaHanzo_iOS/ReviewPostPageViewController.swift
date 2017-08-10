//
//  ReviewPostPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
class ReviewPostPageViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    
    var myTagView = TagView( position: CGPoint( x: 35, y: 450 ), size: CGSize( width: 329, height: 128 ) )
    var placeholder = "당신의 귀한 생각.."
    var tagArray = [String]()
    var textFieldWidth = CGFloat(30)
    var textFieldText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates
        myTextView.delegate = self as! UITextViewDelegate
        
        //view border setting
        myView.layer.borderColor = UIColor.gray.cgColor
        myView.layer.borderWidth = 0.5
        myView.layer.cornerRadius = 10.0
        //textview border setting
        myTextView.layer.borderColor = UIColor(red: CGFloat(112.0/255.0), green: CGFloat(182.0/255.0), blue: CGFloat(229.0/255.0), alpha: CGFloat(1.0)).cgColor
        myTextView.layer.borderWidth = 0.5
        myTextView.layer.cornerRadius = 3.0
        //setting placeholder
        myTextView.text = placeholder
        myTextView.textColor = UIColor.lightGray
        //determine whether it is editting tags or not
        if tagArray.count == 0 {
            myTextView.becomeFirstResponder() }
        myTextView.selectedTextRange = myTextView.textRange(from: myTextView.beginningOfDocument, to: myTextView.beginningOfDocument)
        //imageview border setting
        myImageView.layer.cornerRadius = myImageView.frame.width / 2
        myImageView.layer.masksToBounds = true
        
        self.view.addSubview( myTagView )
        
        //keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewPostPageViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    func textFieldDidChange(_ textField: UITextField) {
        print(textField.text!)
        textFieldText = textField.text!
    }
    

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func postButtonTouched(_ sender: Any) {
        //if user insert same text as placeholder, it will not send post.
        //지금은 그냥 놔두지만 나중에 user가 placeholder와 똑같은 글을 쓸때도 send가되게 바꿔야 함.
        if myTextView.text != placeholder{
            FirebaseModel().postReview(review: myTextView.text, userID: "kim", tagArray: myTagView.getTags(withPrefix: false))
            //print(myTagView.getTags(withPrefix: true))
            print("sent post")
        }
        else{
            print("the post is empty")
        }
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
/////////////////////textview_delegate/////////////////////////
extension ReviewPostPageViewController: UITextViewDelegate{
    
    //setting placeholder to appear only when textview is empty
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText!.isEmpty {
            
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}



///////////////////////textfield_delegate/////////////////////////
extension ReviewPostPageViewController:  UITextFieldDelegate{
    //when textfield enter!
    
    //textfield 크기가 이전 입력값보다 10 크게 하는 꼼수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if TagFilter().isValid3(newString){
            //textFieldText = newString
            //print(textFieldText)
            //print(string)
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != ""{
        print("insert tag: \(String(describing: textField.text!))")
        tagArray.append("#"+textField.text!)
        textField.text = ""
        textFieldText = ""
        }
        return true
    }
}
