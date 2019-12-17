
import UIKit
import ObjectMapper

class VerifyModel: BaseModel {
    var apiToken: String?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        apiToken <- map["Api_Token"]
    }
}
