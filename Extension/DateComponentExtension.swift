
import UIKit

extension DateComponents {
    var nextMonth : DateComponents {
        
        var dateComponent = self
        
        dateComponent.month! += 1
        if dateComponent.month! == 13 {
            dateComponent.year! += 1
            dateComponent.month! = 1
        }
        
        return dateComponent
    }
}

