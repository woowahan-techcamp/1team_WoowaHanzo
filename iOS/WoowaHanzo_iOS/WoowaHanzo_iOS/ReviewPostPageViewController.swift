//
//  ReviewPostPageViewController.swift
//  WoowaHanzo_iOS
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers_dain. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class ReviewPostPageViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var myContentView: UIView!
    //@IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var myButton: UIBarButtonItem!
    
    var myTagView = TagView( position: CGPoint( x: 20, y: 380 ), size: CGSize( width: 320, height: 128 ) )
    var placeholder = "당신의 귀한 생각.."
    var tagArray = [String]()
    var imageNameArray = [String]()
    var imageArray = [UIImage]()
    var textFieldWidth = CGFloat(30)
    var textFieldText = ""
    var keyboardmove = CGFloat(0)
    var savedkeyboardSize = CGRect()
    let imagePickerController = BSImagePickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //게시를 누르지 않고 다른 탭을 누르는 경우 알림을 띄우도록
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        myTagView.removeFromSuperview()
        myTagView = TagView( position: CGPoint( x: 20, y: 380 ), size: CGSize( width: 320, height: 128 ) )
        myTextView.delegate = self as! UITextViewDelegate
                //keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name(rawValue: "keyboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.fitView), name: NSNotification.Name(rawValue: "fitview"), object: nil)
        
        //view border setting
        myView.layer.borderColor = UIColor.gray.cgColor
        myView.layer.borderWidth = 0.5
        myView.layer.cornerRadius = 10.0
        //textview border setting
        myTextView.layer.borderColor = UIColor(red: CGFloat(112.0/255.0), green: CGFloat(182.0/255.0), blue: CGFloat(229.0/255.0), alpha: CGFloat(1.0)).cgColor
        myTextView.layer.borderWidth = 0.5
        myTextView.layer.cornerRadius = 3.0
        //textview line spacing
        //let style = NSMutableParagraphStyle()
        //style.lineSpacing = 50
        //let attributes = [NSParagraphStyleAttributeName : style]
        //myTextView.attributedText = NSAttributedString(string: myTextView.text, attributes: attributes)
        //setting placeholder
        myTextView.text = placeholder
        myTextView.textColor = UIColor.lightGray
        
        //determine whether it is editting tags or not
        if tagArray.count == 0 {
            myTextView.becomeFirstResponder() }
        myTextView.selectedTextRange = myTextView.textRange(from: myTextView.beginningOfDocument, to: myTextView.beginningOfDocument)
        fitView()
        //imageview border setting
        myImageView.layer.cornerRadius = myImageView.frame.width / 2
        myImageView.layer.masksToBounds = true
        
        self.myView.addSubview( myTagView )
        myContentView.addSubview(myView)
        myScrollView.addSubview(myContentView)
        myScrollView.contentSize.height = 1500
        
        
        //keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewPostPageViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //myView.addGestureRecognizer(tap)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            savedkeyboardSize = keyboardSize
            if self.view.frame.origin.y == 0{
                //keyboardSize.height
                keyboardmove = min((self.view.frame.height-self.myTagView.frame.origin.y-self.myTagView._scrollView.contentSize.height - 65 - keyboardSize.height), (CGFloat)(0))
                self.view.frame.origin.y += keyboardmove
                //self.myView.frame.origin.y += keyboardmove
            }
        }
        else{
            print("called")
            self.view.frame.origin.y -= keyboardmove
            keyboardmove = min((self.view.frame.height-self.myTagView.frame.origin.y-self.myTagView._scrollView.contentSize.height - 65 - savedkeyboardSize.height), (CGFloat)(0))
            self.view.frame.origin.y += keyboardmove
            //self.myView.frame.origin.y += keyboardmove
            print(savedkeyboardSize.height)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //if self.view.frame.origin.y != 0{
            self.view.frame.origin.y -= keyboardmove
            //self.myView.frame.origin.y -= keyboardmove
            //}
        }
    }
    func fitView(){
        let contentSize = self.myTextView.sizeThatFits(self.myTextView.bounds.size)
        var frame = self.myTextView.frame
        frame.size.height = max(contentSize.height, 70)
        self.myTextView.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.myTextView, attribute: .height, relatedBy: .equal, toItem: self.myTextView, attribute: .width, multiplier: myTextView.bounds.height/myTextView.bounds.width, constant: 1)
        self.myTextView.addConstraint(aspectRatioTextViewConstraint)
        
        var frame2 = self.myTagView.frame
        frame2.origin.y = self.myTextView.frame.origin.y + myTextView.frame.height + 10
        self.myTagView.frame = frame2
        self.myTagView._basePosition = CGPoint(x: frame2.origin.x, y: frame2.origin.y)
        
        
        var frame3 = self.shadowView.frame
        frame3.origin.y = self.myTextView.frame.origin.y + myTextView.frame.height + 10
        frame3.size.height = self.myTagView._scrollView.frame.height
        shadowView.frame = frame3
        //print(myTagView._scrollView.contentSize.height)
        
        //var frame4 = self.myView.frame
        myView.frame.size.height = shadowView.frame.origin.y + shadowView.frame.height + 10
        //myButton.frame.origin.y = myView.frame.origin.y + myView.frame.height + 17
        
        var contentSize2 = myScrollView.contentSize
        contentSize2.height = myView.frame.size.height + 80
        self.myScrollView.contentSize = contentSize2
        
        
        //let contentSize2 = self.myView.sizeThatFits(self.myView.bounds.size)
        //var frame3 = self.myView.frame
        //frame3.size.height = contentSize2.height
        //myView.frame = frame3
        //myScrollView.contentSize = CGSize(width: Int(self.view.frame.width), height: Int(contentSize2.height))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboard"), object: nil)
        
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
            FirebaseModel().postReview(review: myTextView.text, userID: "kim", tagArray: myTagView.getTags(withPrefix: false), timestamp: Int(-1.0 * Date().timeIntervalSince1970),images:["baemin.png"])
            //print(myTagView.getTags(withPrefix: true))
            print("sent post")
            self.tabBarController?.selectedIndex = 0
            
            //등록 표시 나 화면 전환등의 효과 애니메이션 필요.
        }
        else{
            print("the post is empty")
        }
    }
    
    
    @IBAction func addButtonTouched(_ sender: Any) {
        bs_presentImagePickerController(imagePickerController, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            print("Finish: \(assets)")
        }, completion: nil)
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
        fitView()
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
