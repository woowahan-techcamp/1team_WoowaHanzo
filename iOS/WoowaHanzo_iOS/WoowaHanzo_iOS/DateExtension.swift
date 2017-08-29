
import Foundation
import UIKit

extension Date {
    
    func getDatelabel(timestamp: Int) -> String{
        let myDate = Date(timeIntervalSince1970: TimeInterval(timestamp/1000))
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: myDate)
        let month = calendar.component(.month, from: myDate)
        let day = calendar.component(.day, from: myDate)
        
        let datelabel = "\(month)월 \(day)일, \(year)년"
        return datelabel
    }
    
    func postTimeDisplay(timestamp: Int) -> String{
        var timeago = ""
        let time = -1*timestamp
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
        if timeago == "0초 전"{
            timeago = "방금 전"
        }
        return timeago
    }
}
