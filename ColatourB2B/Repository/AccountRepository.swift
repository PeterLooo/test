

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
    
    func getRefreshToke(loginRequest: LoginRequest) -> Single<LoginResponse> {
        let api = APIManager.shared
            .getRefreshToken(loginRequest: loginRequest)
        
        return AccountRepository.shared.apiToken
            .flatMap{ model -> Single<[String:Any]> in
                return api
            }
            .flatMap{ response -> Single<LoginResponse> in
                let loginResponse:LoginResponse = LoginResponse(JSON: response)!
                return Single.just(loginResponse)
            }
            .flatMap{ response -> Single<LoginResponse> in
                return self.procressRefreshToken(loginResponse: response)
            }
    }
    
    func passwordModify(passwordModifyRequest: PasswordModifyRequest) -> Single<PasswordModifyResponse> {
        
        let api = APIManager.shared.passwordModify(passwordModifyRequest: passwordModifyRequest)
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .flatMap{ response -> Single<PasswordModifyResponse> in
                let passwordModifyResponse: PasswordModifyResponse = PasswordModifyResponse(JSON: response)!
                return Single.just(passwordModifyResponse)
            }
            .flatMap{ response -> Single<PasswordModifyResponse> in
                return self.procressRefreshToken(passwordModifyResponse: response)
            }
    }
    
    private func procressRefreshToken(passwordModifyResponse: PasswordModifyResponse) -> Single<PasswordModifyResponse> {
        
        switch passwordModifyResponse.modifyPassowrd?.modifyMark == true {
            
        case true:
             MemberRepository.shared.setLocalUserToken(refreshToken: passwordModifyResponse.modifyPassowrd!.refreshToken!, accessToken: passwordModifyResponse.modifyPassowrd!.accessToken!)
            
        case false:
            MemberRepository.shared.removeLocalAccessToken()
            MemberRepository.shared.removeLocalRefreshToken()
        }
        
        return Single.just(passwordModifyResponse)
    }
    
    private func procressRefreshToken(loginResponse: LoginResponse) -> Single<LoginResponse> {
        
        MemberRepository.shared.setEmployeeMark(emloyeeMark: loginResponse.employeeMark ?? false)
        MemberRepository.shared.setAllowTour(allowTour: loginResponse.allowTour ?? false)
        MemberRepository.shared.setAllowTkt(allowTkt: loginResponse.allowTkt ?? false)
        MemberRepository.shared.setTabBarLinkType(linkType: loginResponse.linkType!.rawValue)
        MemberRepository.shared.setLocalUserToken(refreshToken: loginResponse.refreshToken!, accessToken: loginResponse.accessToken!)

        return Single.just(loginResponse)
    }
    
    func getAccessToken(getLocalToken: Bool = true) -> Single<LoginResponse>{
        let refreshToken = UserDefaultUtil.shared.refreshToken
        let accessToken = UserDefaultUtil.shared.accessToken
        
        if refreshToken == nil || refreshToken == "" {
            MemberRepository.shared.removeLocalAccessToken()
            MemberRepository.shared.removeLocalRefreshToken()
            return Single.error(APIError.init(type: .presentLogin, localDesc: "", alertMsg: ""))
        }
        if accessToken != nil && getLocalToken == true {
            let respones = LoginResponse()
            respones.accessToken = UserDefaultUtil.shared.accessToken
            respones.refreshToken = UserDefaultUtil.shared.refreshToken
            return  Single.just(respones)
        }
        APIManager.shared.cancelAllRequest()
        let api = APIManager.shared.getAccessToken(refreshToken: refreshToken!)
        return AccountRepository.shared.apiToken
        .flatMap{ model -> Single<[String:Any]> in
            return api
        }
        .flatMap{ response -> Single<LoginResponse> in
            let loginResponse:LoginResponse = LoginResponse(JSON: response)!
            return Single.just(loginResponse)
        }.flatMap{ response -> Single<LoginResponse> in
            return self.procressAccessToken(loginResponse: response)
        }
        
    }
    
    private func procressAccessToken(loginResponse: LoginResponse) -> Single<LoginResponse> {
        
        MemberRepository.shared.setAllowTour(allowTour: loginResponse.allowTour ?? false)
        MemberRepository.shared.setAllowTkt(allowTkt: loginResponse.allowTkt ?? false)
        
        switch loginResponse.accessToken.isNilOrEmpty {
        case true:
            MemberRepository.shared.removeLocalAccessToken()
            MemberRepository.shared.removeLocalRefreshToken()
            return getAccessToken(getLocalToken: false)
        case false:
            MemberRepository.shared.setLocalUserToken(refreshToken: loginResponse.refreshToken!, accessToken: loginResponse.accessToken!)
            return Single.just(loginResponse)
        }
    }
    
    func getAccessWeb(webUrl:String) -> Single<String> {
        let api = APIManager.shared.getAccessWeb(webUrl: webUrl)
        return AccountRepository.shared.getAccessToken()
        .flatMap{_ in api}
        .map{ WebUrl(JSON: $0)!.webUrl!}
    }
    
    func getWebViewTourShareList(tourCode: String, tourDate: String) -> Single<WebViewTourShareResponse.ItineraryShareData>{
        let api = APIManager.shared.getWebViewTourShareList(tourCode: tourCode, tourDate: tourDate)
        return AccountRepository.shared.getAccessToken()
            .flatMap{ _ in api}
            .map{WebViewTourShareResponse(JSON: $0)!.itineraryShareData!}
    }
    
    func getVersionRule() -> Single<VersionRuleReponse.Update?> {
        let api = APIManager.shared.getVersionRule()
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ VersionRuleReponse(JSON: $0)!.update}
    }
    
    func getBulletin() -> Single<BulletinResponse.Bulletin?> {
        let api = APIManager.shared.getBulletin()
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{ BulletinResponse(JSON: $0)!.bulletin}
    }
    
    func memberLogout() -> Single<Any> {
        
        let api = APIManager.shared.memberLogout()
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{BaseModel(JSON: $0)!}
    }
    
    func getMemberIndex()-> Single<MemberIndexResponse> {
        let api = APIManager.shared.getMemberIndex()
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ MemberIndexResponse(JSON: $0)!}
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
