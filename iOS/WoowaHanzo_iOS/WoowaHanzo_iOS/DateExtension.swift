
import Foundation
import UIKit

extension Date {

    func postTimeDisplay(postDate: Int)->String{
//        
            let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        let postDate: Date? = dateformatter.date(from: postDate)
//        
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        formatter.maximumUnitCount = 1
//        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
//        let timeString = formatter.string(from: postDate!, to: self)
//        //print(timeString)
//        if let timeStr = timeString{
//            if timeStr == "0초" || timeStr == "1초"{
//                return "방금 전"
//            }
//        }
//        let formatString = NSLocalizedString("%@ 전", comment: "")
//        
        
//        return String(format: formatString, timeString!)
        let myDate = Date(timeIntervalSince1970: TimeInterval(postDate))
        let str = dateformatter.string(from: myDate)
        return str
    }
}
