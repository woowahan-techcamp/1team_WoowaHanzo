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
import Kingfisher
import NVActivityIndicatorView


class ReviewPostPageViewController: UIViewController,NVActivityIndicatorViewable {
    
    
    var ref: DatabaseReference!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userTearLabel: UILabel!
    @IBOutlet weak var userNickNameLabel: UILabel!
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
    var selectedIndex = -1
    var ProfileImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if !AuthModel.isLoginStatus(){
            //로그인이 되어있지 않은 상태
            let alert = UIAlertController(title: "로그인 후 이용하실 수 있습니다. ", message: "로그인 하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
                self.present(controller, animated: false, completion: nil)
                //self.navigationController?.pushViewController(controller, animated: true)
                //self.show(controller, sender: self)
            })
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
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
            //로그인이 되었다면? 내 마이페이지를 보여줘야함. - did
            FirebaseModel().loadProfileImageFromUsers()
            FirebaseModel().loadUserInfo(pageCase: 1)
            loadUserInformation()
            
            if shouldloadview{
                //여기에 프로필 이미지
                FirebaseModel().loadProfileImageFromUsers()
                FirebaseModel().loadUserInfo(pageCase: 1)
                print("응앙ㅇ\(User.currentLoginedUserNickName,User.currentLoginedUserTitle)")
                
                print(User.currentLoginedUserNickName,User.currentLoginedUserTitle)
                userTearLabel.text = User.currentLoginedUserRankName
                shouldloadview = false
                myCollectionView.dataSource = self
                myCollectionView.delegate = self
                myCollectionView.allowsSelection = true
                
                imageNameArray = [String]()
                imageArray = [UIImage]()
                imageAssets = [PHAsset]()
                
                //userProfileImage.image = UIImage(named: "profile.png")
                //userTearLabel.text = "치킨왕자"
                userNickNameLabel.text = User.currentLoginedUserNickName
                myTagView.removeFromSuperview()
                myTagView = TagView( position: CGPoint( x: 0, y: 380 ), size: CGSize( width: 320, height: 50 ) )
                myTextView.delegate = self as UITextViewDelegate
                //keyboard notification
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name(rawValue: "keyboard"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.fitView), name: NSNotification.Name(rawValue: "fitview"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.escapecancel), name: NSNotification.Name(rawValue: "escapecancel"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.escapeOK), name: NSNotification.Name(rawValue: "escapeOK"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(loadPorfileImage(_ :)), name: NSNotification.Name(rawValue: "ReturnProfileImageURL"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(loadUserInformation), name: NSNotification.Name(rawValue: "LoadUserInfo1"), object: nil)
                
                
                
                
                myTextView.layer.borderColor = UIColor.lightGray.cgColor
                myTextView.layer.borderWidth = 0.5
                myTextView.layer.cornerRadius = 3.0
                
                //setting placeholder
                myTextView.text = placeholder
                myTextView.textColor = UIColor.lightGray
                
                //determine whether it is editting tags or not
                myTextView.becomeFirstResponder()
                myTextView.selectedTextRange = myTextView.textRange(from: myTextView.beginningOfDocument, to: myTextView.beginningOfDocument)
                
                //imageview border setting
                myImageView.layer.cornerRadius = myImageView.frame.width / 2
                myImageView.layer.masksToBounds = true
                
                myCollectionView.removeFromSuperview()
                myView.addSubview(myCollectionView)
                DispatchQueue.main.async{
                    self.myCollectionView.reloadData()
                }
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
    }
    func loadPorfileImage(_ notification : Notification){
        let profileImageUrl = notification.userInfo?["profileImageUrl"] as! String
        Storage.storage().reference(withPath: "profileImages/" + profileImageUrl).downloadURL { (url, error) in
            self.myImageView?.kf.setImage(with: url)
            KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                if let image = image{
                    User.currentUserProfileImage = image
                    self.myImageView?.kf.setImage(with: url)
                }
            })
        }
    }
    func loadUserInformation(){
        print("loadUserInformation")
        self.userNickNameLabel.text = User.currentLoginedUserNickName
        self.userTearLabel.text = User.currentLoginedUserRankName
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if !AuthModel.isLoginStatus(){
            
            let alert = UIAlertController(title: "로그인 후 이용하실 수 있습니다. ", message: "로그인 하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (cancelAction) in
                let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
                self.present(controller, animated: false, completion: nil)
                //self.navigationController?.pushViewController(controller, animated: true)
                //self.show(controller, sender: self)
            })
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginNavigation")
                
                self.show(controller, sender: self)
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else{
            //로그인이 되었다면? 내 마이페이지를 보여줘야함.
            
            FirebaseModel().loadProfileImageFromUsers()
            FirebaseModel().loadUserInfo(pageCase: 1)
            loadUserInformation()
            print(User.currentLoginedUserNickName, User.currentLoginedUserRankName,1234)
            
            if shouldloadview{
                FirebaseModel().loadProfileImageFromUsers()
                FirebaseModel().loadUserInfo(pageCase: 1)
                print("응앙ㅇ\(User.currentLoginedUserNickName,User.currentLoginedUserTitle)")
                
                userTearLabel.text = User.currentLoginedUserRankName
                shouldloadview = false
                myCollectionView.dataSource = self
                myCollectionView.delegate = self
                myCollectionView.allowsSelection = true
                
                imageNameArray = [String]()
                imageArray = [UIImage]()
                imageAssets = [PHAsset]()
                
                
                //userProfileImage.image = UIImage(named: "profile.png")
                //userTearLabel.text = "치킨왕자"
                userNickNameLabel.text = User.currentLoginedUserNickName
                print(User.currentLoginedUserNickName, User.currentLoginedUserTitle,1234)
                myTagView.removeFromSuperview()
                myTagView = TagView( position: CGPoint( x: 0, y: 380 ), size: CGSize( width: 320, height: 50 ) )
                myTextView.delegate = self as UITextViewDelegate
                //keyboard notification
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.keyboardWillShow), name: NSNotification.Name(rawValue: "keyboard"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(ReviewPostPageViewController.fitView), name: NSNotification.Name(rawValue: "fitview"), object: nil)
                
                myTextView.layer.borderColor = UIColor.lightGray.cgColor
                myTextView.layer.borderWidth = 0.5
                myTextView.layer.cornerRadius = 3.0
                
                myTextView.text = placeholder
                myTextView.textColor = UIColor.lightGray
                
                //determine whether it is editting tags or not
                myTextView.becomeFirstResponder()
                myTextView.selectedTextRange = myTextView.textRange(from: myTextView.beginningOfDocument, to: myTextView.beginningOfDocument)
                
                //imageview border setting
                myImageView.layer.cornerRadius = myImageView.frame.width / 2
                myImageView.layer.masksToBounds = true
                
                myCollectionView.removeFromSuperview()
                myView.addSubview(myCollectionView)
                DispatchQueue.main.async{
                    self.myCollectionView.reloadData()
                }
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
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if myTextView.textColor != UIColor.lightGray {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "escape"), object: nil)
            //print("noticalled")
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "escapefalse"), object: nil)
            //print("noticalled")
        }
        
    }
    
    //게시를 누르지 않고 다른 탭을 누르는 경우 알림을 띄우도록
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            savedkeyboardSize = keyboardSize
            if self.view.frame.origin.y == 0{
                //keyboardSize.height
                keyboardmove = min((self.view.frame.height-self.myTagView.frame.origin.y-self.myTagView._scrollView.contentSize.height - 200 - keyboardSize.height), (CGFloat)(0))
                self.myContentView.frame.origin.y += keyboardmove
            }
        }
        else{
            
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
            
            self.myContentView.frame.origin.y -= keyboardmove
            self.myContentView.frame.origin.y = 0
            
            
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
        
        print("myViewincreased: \(myView.frame.size.height)")
        //왜 바뀐대로 적용안되는지 모르겠다.
        
        var contentSize2 = myScrollView.contentSize
        contentSize2.height = myView.frame.size.height + 80
        self.myScrollView.contentSize = contentSize2
        self.myContentView.frame.size.height = myView.frame.size.height + 80
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboard"), object: nil)
        
    }
    func dismissKeyboard() {
     
        view.endEditing(true)
    }
    
    func escapecancel(){
        self.shouldloadview = false
    }
    func escapeOK(){
        self.shouldloadview = true
    }
    
    
    @IBAction func postButtonTouched(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postDate = formatter.string(from: Date())
        
        //글자가 회색이면 안보내게 하자.
        if myTextView.textColor != UIColor.lightGray{
            
            if let user = Auth.auth().currentUser{
                FirebaseModel().postReview(review: myTextView.text, userID: User.currentLoginedUserNickName, tagArray: myTagView.getTags(withPrefix: false), timestamp: Int(-1000 * Date().timeIntervalSince1970),images:self.imageNameArray, uid: user.uid)
                FirebaseModel().postImages(assets: self.imageAssets, names: self.imageNameArray)
                print(self.imageNameArray)
                print("sent post")
                
                
                let size = CGSize(width: 30, height: 30)
                
                DispatchQueue.main.async {
                    self.startAnimating(size, message: "Loading...", type: .ballTrianglePath)
                    
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.stopAnimating()
                    let storyboard = UIStoryboard(name: "MainLayout", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "mainLayout")
                    self.present(controller, animated: false, completion: nil)
                    
                }
                
                
            }
            
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
      
        if updatedText!.isEmpty {
            
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            myButton.isEnabled = false
            
            return false
        }
            
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
        cell.imageView.contentMode = UIViewContentMode.scaleAspectFill
        cell.imageView.clipsToBounds = true
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
