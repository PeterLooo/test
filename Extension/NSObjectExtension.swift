
import Foundation

extension NSObject{
    func allPropertys() -> [String]{
        var count:CUnsignedInt = 0
        let property = class_copyPropertyList(self.classForCoder, &count)
        var arr = [String]()
        for i in 0..<(Int(count)) {
            let strKey = NSString(cString: property_getName(property![i]), encoding: String.Encoding.utf8.rawValue)! as String
            arr.append(strKey)
        }
        return arr
    }
}
