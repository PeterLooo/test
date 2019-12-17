

import UIKit
import RxSwift
import RxCocoa

class AccountRepository: NSObject {
    fileprivate var dispose = DisposeBag()
    static let shared = AccountRepository()
    
    func getApiInit() -> Single<String> {
        var apiBasic: Single<String>? = nil
        
        apiBasic = AccountRepository.shared.apiToken
        
        return apiBasic!
    }
    
    private func procressToken(apiToken: String) -> Single<String> {
        UserDefaultUtil.shared.apiToken = apiToken
        return Single.just(apiToken)
    }
    
    func getLocalApiToken() -> String? {
        return UserDefaultUtil.shared.apiToken
    }
    
    func removeLocalApiToken() {
        UserDefaultUtil.shared.apiToken = nil
    }
    
    func pushDevice() -> Single<Any> {
        let api = APIManager.shared.pushDevice()
        
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{BaseModel(JSON: $0)!}
    }
    
    func getLocalFirebaseToken() -> String? {
        return UserDefaultUtil.shared.firebaseToken
    }
    
    func procressFirebaseToken(firebaseToken: String) {
        UserDefaultUtil.shared.firebaseToken = firebaseToken
    }
    
    var apiToken: Single<String> {
        var apiToken = UserDefaultUtil.shared.apiToken
        apiToken = removeApiTokenIfExpired(apiToken: apiToken)
        
        if (apiToken == nil || apiToken == "") {
            let deviceName = DeviceUtil.phoneName()
            let uuid = AccountRepository.shared.osUUID
            let accessSecret = EncryptionUtils.des3String(fromText: uuid)!
            
            return APIManager.shared
                .getApiToken(deviceName: deviceName!, accessToken: accessSecret)
                .map{VerifyModel(JSON: $0)! .apiToken!}
                .flatMap({ apiToken -> Single<String> in
                    return self.procressToken(apiToken: apiToken)
                })
        }
        return Single.just(apiToken!)
    }
    
    private func removeApiTokenIfExpired(apiToken: String?) -> String {
        if (apiToken == nil) { return "" }
        if (apiToken == "") { return "" }
        
        let apiTokenValidity = apiToken?.components(separatedBy: "==.").last
        let dateFormatter = DateFormatter()
        dateFormatter.setToBasic(dateFormat: "yyyyMMddHHmmss")
        let date = dateFormatter.date(from: apiTokenValidity!)
        
        if (date == nil) {
            AccountRepository.shared.removeLocalApiToken()
            return ""
        }
        
        var currentDate = Date()
        currentDate.addTimeInterval(60.0 * 60.0 * 8)
        
        if (currentDate.compare(date!) == .orderedDescending) {
            AccountRepository.shared.removeLocalApiToken()
            return ""
        }
        
        return apiToken!
    }
    
    var osUUID: String {
        var uu = UserDefaultUtil.shared.uuid
        
        if (uu == nil) {
            if let string = UIDevice.current.identifierForVendor?.uuidString{
                UserDefaultUtil.shared.uuid = string
                uu = string
            }
        }
        return uu!
    }
    
    override init() {
        super.init()
        
    }
}
