import UIKit

class NickNameLabel: UILabel {
    
    func whenLabelTouchedOnRankPage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(nickNameTouchedOnRankPage))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    func whenLabelTouchedOnMainPage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(nickNameTouchedOnMainpage))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func nickNameTouchedOnRankPage(){
        print("NickNameLabel class")
       NotificationCenter.default.post(name:
        NSNotification.Name(rawValue: "NickNameLableTouched"), object: nil, userInfo: ["NickNameLabel":self.text])
        }
    func nickNameTouchedOnMainpage()
    {
        print(self.text)
    NotificationCenter.default.post(name:
    NSNotification.Name(rawValue: "nickNameLabelTouchedOnMainpage"), object: nil, userInfo: ["NickNameLabel":self.text])
        
    }

    
}
