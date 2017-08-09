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
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var dummyLabel: UILabel!
    
    
    
    //@IBOutlet weak var cellTextField: UITextField!
    
    var placeholder = "당신의 귀한 생각.."
    var tagArray = ["#test1", "#test2", "#test3", "#test4", "#test5"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates
        myTextView.delegate = self as! UITextViewDelegate
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myTextField.delegate = self
        
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
        myTextView.becomeFirstResponder()
        myTextView.selectedTextRange = myTextView.textRange(from: myTextView.beginningOfDocument, to: myTextView.beginningOfDocument)
        //imageview border setting
        myImageView.layer.cornerRadius = myImageView.frame.width / 2
        myImageView.layer.masksToBounds = true
        //collectionview layout
        
        //left allign layout: 다른 layout 예제를 그대로 덮어쓰는 방법 알아보기.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        myCollectionView!.collectionViewLayout = layout
    
    
    }
    @IBAction func postButtonTouched(_ sender: Any) {
        //if user insert same text as placeholder, it will not send post.
        //지금은 그냥 놔두지만 나중에 user가 placeholder와 똑같은 글을 쓸때도 send가되게 바꿔야 함.
        if myTextView.text != placeholder{
            FirebaseModel().postReview(review: myTextView.text, userID: "kim")
            print("sent post")
        }
        else{
            print("the post is empty")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

extension ReviewPostPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return tagArray.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        //if it's label, not textfield
        if indexPath.row < tagArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomLabelCell", for: indexPath) as! CustomLabelCell
            print("updating tag: \(indexPath.row + 1). \(tagArray[indexPath.row])")
        
            cell.label.text = tagArray[indexPath.row]
            cell.label.sizeToFit()
            cell.layer.cornerRadius = 5.0
            
            return cell
        }
            
        //if it's textfield
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomTextFieldCell", for: indexPath) as! CustomTextFieldCell
            cell.textfield.sizeToFit()
            cell.layer.cornerRadius = 5.0
            cell.textfield.delegate = self
            
            return cell
        }
        
        //reload 나중에 추가해야 함.
        //cell 선택하면 삭제시키고 다시 reload도 추가해야함.
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //can not load cell. so make dummylabel and calculate the width of text by sizeTofit()
        //if it's label
        if indexPath.row < tagArray.count{
            dummyLabel.text = tagArray[indexPath.row]
            dummyLabel.sizeToFit()
        }
        else{
            //should make textfield text variable outside and update continuously.
        }
        return CGSize(width: CGFloat(dummyLabel.frame.width + 10), height:CGFloat(25))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //delete only labels
        if indexPath.row < tagArray.count {
            tagArray.remove(at:indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
}

extension ReviewPostPageViewController:  UITextFieldDelegate{

    //not working now.
    func textFieldDidEndEditing(_ textField: UITextField) {
        //textField.sizeToFit()
        
        
        //textfield크기 Cell과 함께 자동으로 줄어들고 늘어나는 부분 고쳐야함.
        //label이랑 textfield 위치 조정.
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        if textField.text != ""{
        print("insert tag: \(String(describing: textField.text!))")
        tagArray.append("#"+textField.text!)
        textField.text = ""
        //print(tagArray)
        myCollectionView.reloadData()
        }
        return true
    }
    //not using now. later set for # in textfield
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length>0  && range.location == 0 {
            print("false")
            return false
        }
        print("true")
        return true
    }
}
