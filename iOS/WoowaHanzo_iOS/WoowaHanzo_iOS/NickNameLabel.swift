import UIKit

class NickNameLabel: UILabel {
    
    func whenLabelTouched() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(nickNameTouched))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    func nickNameTouched(){
        print("NickNameLabel class")
       NotificationCenter.default.post(name:
        NSNotification.Name(rawValue: "NickNameLableTouched"), object: nil, userInfo: ["NickNameLabel":self.text])
    }
    
}
