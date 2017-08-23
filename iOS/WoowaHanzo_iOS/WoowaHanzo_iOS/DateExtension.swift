
import Foundation
import UIKit

extension Date {
    func getDatelabel(timestamp: Int) -> String{
        let myDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: myDate)
        let month = calendar.component(.month, from: myDate)
        let day = calendar.component(.day, from: myDate)
        
        let datelabel = "\(month) \(day)일, \(year)년"
        return datelabel
    }
    func postTimeDisplay(timestamp: Int) -> String{
        var timeago = ""
        var time = -timestamp
        let now = Int(1000 * Date().timeIntervalSince1970)
        let diff = now - time
        if(diff > 24 * 3600000){
            timeago = getDatelabel(timestamp: time)
        }
        else if (diff > 3600000){
            timeago = "\(diff / 3600000)시간 전"
        }
        else if (diff > 60000){
            timeago = "\(diff / 60000)분 전"
        }
        else{
            timeago = "\((diff) / 1000)초 전"
        }
        return timeago
    }

//    func postTimeDisplay(postDate: Int)->String{
////        
//            let dateformatter = DateFormatter()
////        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
////        
////        let postDate: Date? = dateformatter.date(from: postDate)
////        
////        let formatter = DateComponentsFormatter()
////        formatter.unitsStyle = .full
////        formatter.maximumUnitCount = 1
////        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
////        let timeString = formatter.string(from: postDate!, to: self)
////        //print(timeString)
////        if let timeStr = timeString{
////            if timeStr == "0초" || timeStr == "1초"{
////                return "방금 전"
////            }
////        }
////        let formatString = NSLocalizedString("%@ 전", comment: "")
////        
//        
////        return String(format: formatString, timeString!)
//        let myDate = Date(timeIntervalSince1970: TimeInterval(postDate))
//        let str = dateformatter.string(from: myDate)
//        return str
//    }
}
extension Dictionary {
    init(elements:[(Key, Value)]) {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}
