//
//  TVGuideModels.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//

import Foundation
// Model describes channel
struct Channel: Decodable {
    let orderNum: Int
    let accessNum: Int?
    let CallSign: String
    let id: Int
}
// Model to join programs and channels
struct RecentAirTime: Decodable, Hashable {
    let id: Int
    let channelID: Int
}
// Model describes Program Guide item
struct ProgramItem: Decodable, Hashable {
    let startTime: String
    let recentAirTime: RecentAirTime
    let length: Int
    let name: String
    var dateAndTime: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self.startTime)
    }
    
    var hourAndMin: TimeHourAndMin? {
        if let date = self.dateAndTime {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "GMT")!
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            return TimeHourAndMin(hour: hour, minutes: minute)
        }
        return nil
    }
    
    var startHourAndMin: String? {
        if let hourAndMin = self.hourAndMin {
            var hour = hourAndMin.hour
            let min = hourAndMin.minutes
            let minStr = min.description.count == 1 ? "0\(min)" : "\(min)"
            if hour > 12 {
                hour = hour - 12
                let hourStr = hour.description.count == 1 ? "0\(hour)" : "\(hour)"
                return "\(hourStr):\(minStr) PM"
            } else if hour == 12 {
                let hourStr = hour.description.count == 1 ? "0\(hour)" : "\(hour)"
                return "\(hourStr):\(minStr) PM"
            } else {
                let hourStr = hour.description.count == 1 ? "0\(hour)" : "\(hour)"
                return "\(hourStr):\(minStr) AM"
            }
            
        }
        return nil
    }
    
    var startTimeInSecs: Int? {
        if let hourAndMin = hourAndMin {
            let hour = hourAndMin.hour
            let min = hourAndMin.minutes
            return Int((hour * 60 * 60) + (min * 60))
        }
        return nil
    }
    
    var lengthInSecs: Int {
        return self.length * 60
    }
    
    var lenghtMultiple: Int {
        let multiple = self.length / 30
        let remainder = self.length % 30
        if remainder > 15 {
            return multiple + 1
        } else {
            return multiple
        }
    }
}

struct TimeHourAndMin {
    let hour: Int
    let minutes: Int
}

struct TVResponseModels {
    var channelList: [Channel] = []
    var programList: [ProgramItem] = []
    var errorMessage: String = ""
}
