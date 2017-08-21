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
import Firebase

class ReviewPostPageViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var myContentView: UIView!
    //@IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myButton: UIBarButtonItem!
    
    
    var myTagView = TagView( position: CGPoint( x: 20, y: 380 ), size: CGSize( width: 320, height: 50 ) )
    var placeholder = "당신의 귀한 생각.."
    var imageNameArray = [String]()
    var imageArray = [UIImage]()
    var imageAssets = [PHAsset]()
    var textFieldWidth = CGFloat(30)
    var textFieldText = ""
    var keyboardmove = CGFloat(0)
    var savedkeyboardSize = CGRect()
    var shouldloadview = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldloadview{
            shouldloadview = true
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.allowsSelection = true
        myTagView.removeFromSuperview()
        myTagView = TagView( position: CGPoint( x: 0, y: 380 ), size: CGSize( width: 320, height: 50 ) )
        myTextView.delegate = self as UITextViewDelegate
        //keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name(rawValue: "keyboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.fitView), name: NSNotification.Name(rawValue: "fitview"), object: nil)
        
        //view border setting
        //myView.layer.borderColor = UIColor.gray.cgColor
        //myView.layer.borderWidth = 0.5
        //myView.layer.cornerRadius = 10.0
        //textview border setting
        //myTextView.layer.borderColor = UIColor(red: CGFloat(112.0/255.0), green: CGFloat(182.0/255.0), blue: CGFloat(229.0/255.0), alpha: CGFloat(1.0)).cgColor
        myTextView.layer.borderColor = UIColor.lightGray.cgColor
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
        myTextView.becomeFirstResponder()
        myTextView.selectedTextRange = myTextView.textRange(from: myTextView.beginningOfDocument, to: myTextView.beginningOfDocument)
        
        //imageview border setting
        myImageView.layer.cornerRadius = myImageView.frame.width / 2
        myImageView.layer.masksToBounds = true
        
        self.myView.addSubview( myTagView )
        myContentView.addSubview(myView)
        myScrollView.addSubview(myContentView)
        myScrollView.contentSize.height = 1500
        myContentView.frame.size.height = 3000
        
        fitView()
        //keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewPostPageViewController.dismissKeyboard))
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //myView.addGestureRecognizer(tap)
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewPostPageViewController.dismissKeyboard))
        tap2.cancelsTouchesInView = false
        myCollectionView.addGestureRecognizer(tap2)
        
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewPostPageViewController.dismissKeyboard))
        tap3.cancelsTouchesInView = false
        myTagView.addGestureRecognizer(tap3)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let alert = UIAlertController(title: "글 작성이 완료되지 않았습니다.", message: "글 작성을 취소하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
            self.shouldloadview = false
            self.tabBarController?.selectedIndex = 2
        })
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
            self.shouldloadview = true
        })
//        if myTextView.textColor != UIColor.lightGray {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            alert.addAction(cancel)
//            alert.addAction(ok)
//            //self.present(alert, animated: true, completion: nil)
//        }
  //      }


    }
    
    //게시를 누르지 않고 다른 탭을 누르는 경우 알림을 띄우도록
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            savedkeyboardSize = keyboardSize
            if self.view.frame.origin.y == 0{
                //keyboardSize.height
                keyboardmove = min((self.view.frame.height-self.myTagView.frame.origin.y-self.myTagView._scrollView.contentSize.height - 200 - keyboardSize.height), (CGFloat)(0))
                //self.view.frame.origin.y += keyboardmove
                self.myContentView.frame.origin.y += keyboardmove
                //self.myContentView.frame.origin.y += keyboardmove
                
            }
        }
        else{
            //self.view.frame.origin.y -= keyboardmove
            //self.myContentView.frame.origin.y -= keyboardmove
            self.myContentView.frame.origin.y -= keyboardmove
            
            keyboardmove = min((self.view.frame.height-self.myTagView.frame.origin.y-self.myTagView._scrollView.contentSize.height - 200 - savedkeyboardSize.height), (CGFloat)(0))
            //self.view.frame.origin.y += keyboardmove
            self.myContentView.frame.origin.y += keyboardmove
            //self.myContentView.frame.origin.y += keyboardmove
            
            print(savedkeyboardSize.height)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            //if self.view.frame.origin.y != 0{
            //self.view.frame.origin.y -= keyboardmove
            self.myContentView.frame.origin.y -= keyboardmove
            self.myContentView.frame.origin.y = 0
            //self.myContentView.frame.origin.y -= keyboardmove
            
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
        
        var frame4 = self.myCollectionView.frame
        frame4.origin.y = shadowView.frame.origin.y + shadowView.frame.height + 5
        myCollectionView.frame = frame4
        
        //var frame4 = self.myView.frame
        
        var frame5 = self.myView.frame
        frame5.size.height = myCollectionView.frame.origin.y + myCollectionView.frame.height + 200
        myView.frame = frame5
        
        //considering imageview height
        //myButton.frame.origin.y = myView.frame.origin.y + myView.frame.height + 17
        print("myViewincreased: \(myView.frame.size.height)")
        //왜 바뀐대로 적용안되는지 모르겠다.
        
        var contentSize2 = myScrollView.contentSize
        contentSize2.height = myView.frame.size.height + 80
        self.myScrollView.contentSize = contentSize2
        self.myContentView.frame.size.height = myView.frame.size.height + 80
        
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postDate = formatter.string(from: Date())
        //if user insert same text as placeholder, it will not send post.
        //지금은 그냥 놔두지만 나중에 user가 placeholder와 똑같은 글을 쓸때도 send가되게 바꿔야 함.
        
        //글자가 회색이면 안보내게 하자.
        if myTextView.textColor != UIColor.lightGray{
            //DispatchQueue.global().sync{
            if let user = Auth.auth().currentUser{
                    FirebaseModel().postReview(review: myTextView.text, userID: user.email!, tagArray: myTagView.getTags(withPrefix: false), timestamp: Int(-1000 * Date().timeIntervalSince1970),images:self.imageNameArray, uid: user.uid)
            FirebaseModel().postImages(assets: self.imageAssets, names: self.imageNameArray)
            //print(myTagView.getTags(withPrefix: true))
            print(self.imageNameArray)
            print("sent post")
            
            let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
            self.present(controller, animated: false, completion: nil)
            
            }
            //self.tabBarController?.selectedIndex = 0
            
            //다른 탭 누르면: 나가시겠습니까 알러트.
            
            
        }
        else{
            print("the post is empty")
        }
    }
    
    
    @IBAction func addButtonTouched(_ sender: Any) {
        let imagePickerController = BSImagePickerViewController()
        bs_presentImagePickerController(imagePickerController, animated: true,
        select: { (asset: PHAsset) -> Void in
            print("Selected")
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel")
        }, finish: { (assets: [PHAsset]) -> Void in
            //self.imageAssets = assets
            //FirebaseModel().postImages(assets: assets)
            self.shouldloadview = false
            for asset in assets{
                let name = asset.value(forKey:"filename") as! String
                let extlist = name.components(separatedBy: ".")
                let ext = extlist[extlist.count - 1]
                
                self.imageAssets.append(asset)
                let image = FirebaseModel().getAssetThumbnail(asset: asset)
                self.imageArray.append(image)
                self.imageNameArray.append("\(Date().timeIntervalSince1970).\(ext)")
                print("\(Date().timeIntervalSince1970).\(ext)")
            }
            print("done \(self.imageArray)")
            DispatchQueue.main.async{
                self.myCollectionView.reloadData()
            }
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
        //글자수 제한.
        let newLength = textView.text.characters.count + text.characters.count - range.length
        if newLength > 500 {
            return false
        }
        
        let currentText = textView.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText!.isEmpty {
            
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            myButton.isEnabled = false
            
            return false
        }
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
            myButton.isEnabled = true
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


extension ReviewPostPageViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.imageArray.count + 1)
        return self.imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttoncell", for: indexPath as IndexPath)
            cell.layer.cornerRadius = 3.0
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseidentifier", for: indexPath as IndexPath) as! MyCollectionCell
        cell.imageView.image = imageArray[indexPath.row - 1]
        cell.layer.cornerRadius = 3.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            imageArray.remove(at: indexPath.row - 1)
            imageNameArray.remove(at: indexPath.row - 1)
            imageAssets.remove(at: indexPath.row - 1)
            myCollectionView.deleteItems(at: [indexPath])
            print("delete")
        }
    }
}
