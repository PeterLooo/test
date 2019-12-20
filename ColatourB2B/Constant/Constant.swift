
import UIKit

//import TPClient
import CoreLocation

let appDelegate = UIApplication.shared.delegate as! AppDelegate?
let MainWindow = appDelegate?.window!

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

var statusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        let app = UIApplication.shared
        return app.statusBarFrame.size.height
        
    } else {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        return statusBar?.frame.size.height ?? 0
    }
}
let kScaleFactor = screenWidth/375.0 // iPhone 6 base width: 375.0
let kSectionHeaderHeight = CGFloat(46.0)
let kEmptySectionHeaderHeight = CGFloat(23.0)
let kCheckTime = Double(30*24*60*60) // Time interval for 30 days

var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(abbreviation: "UTC+8:00")!
    calendar.locale = Locale(identifier: "zh_TW")
    return calendar
}

var calendarForDatePicker: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(abbreviation: "UTC+8:00")!
    calendar.locale = Locale(identifier: "zh_TW")
    return calendar
}

var isLogin: Bool {
    let memberToken = UserDefaultUtil.shared.accessToken
    if memberToken == nil || memberToken == "" {
        return false
    }else{
        return true
    }
}

var leaveAppSeconds: Double {
    let minutes = 10.0
    let seconds = minutes * 60.0
    return seconds
}

let defaultDate = "1900/01/01"
let defaultDateList = ["1900/01/01",
                       "1900-01-01T00:00:00"]

var dateFormatList: [String] = ["yyyy-MM-dd HH:mm:ss",
                                "yyyy-MM-dd'T'HH:mm:ss.SSS",
                                "yyyy-MM-dd'T'HH:mm:ss",
                                "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                "yyyy-MM-dd'T'HH:mm:ssZ",
                                "yyyy-MM-dd HH:mm:ss Z",
                                "yyyy/MM/dd",
                                "MM/dd HH:mm"]

let introductionVersion = 1




