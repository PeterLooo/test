
import RxSwift
import Alamofire
import Reachability
import CoreLocation
import RxCocoa

class APIManager: NSObject {
    static let shared = APIManager()
    let reachability = Reachability()!
    var isReachable = Variable(true)
    
    private var progress:Progress!
    private var context = 0
    
    lazy var requestManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APITimeout
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: config)
    }()
    
    override init() {
        super.init()
        
        let reachabilityManager = NetworkReachabilityManager.init(host:"www.apple.com")
        let isInternetReachable = (reachabilityManager?.isReachable) ?? false
        
        self.isReachable.value = isInternetReachable
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.isReachable.value = false
            }
        }
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.isReachable.value = true
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            #if DEBUG
            print("Error")
            #endif
        }
    }
    
    deinit {
        progress.removeObserver(self, forKeyPath: "apiCompleted")
    }
    
    fileprivate func manager(method: HTTPMethod, appendUrl: String, url: APIUrl, parameters: [String: Any]?, appendHeaders: [String: String]?) -> Single<[String:Any]> {
        
        return Single.create { (single) -> Disposable in
            
            let param = (parameters) ?? [String:Any]()
            let headers: HTTPHeaders = self.getHttpHeadersWith(method: method, appendHeaders: appendHeaders)
            let requestUrl: String = self.getRequestUrlWith(url: url, appendUrl: appendUrl)
            let encode: ParameterEncoding = self.getEncodeWith(method: method)
            
            self.printRequest(requestUrl, headers, param)
            
            if (self.isReachable.value == false) {
                let err = APIError.init(type: .noInternetException, localDesc: "The Internet connection appears to be offline.", alertMsg: "")
                single(.error(err))
                FirebaseCrashManager.recordError(err, api: url, method: method)
                return Disposables.create()
            }
            
            self.requestManager
                .request(requestUrl, method: method, parameters: param, encoding: encode, headers: headers)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        if (value is [String:Any]) {
                            self.printResponse(requestUrl, value)
                            single(.success(value as! [String:Any]))
                        } else {
                            let err = APIError.init(type: .otherException, localDesc: "It's success.But AlertMsg doesn't exist.", alertMsg: "")
                            self.printErrorResponse(requestUrl, response, err, alertMsg: "")
                            FirebaseCrashManager.recordError(err, api: url, method: method)
                            single(.error(err))
                        }
 
                    case .failure(let error):
                        
                        var json: [String : String] = [:]
                        
                        if let data = response.data {
                            do{
                                json = try (JSONSerialization.jsonObject(with: data, options: []) as! [String: String])
                            }catch{
                                json["AlertMsg"] = ""
                            }
                        }
                        
                        let alertMsg = json["AlertMsg"] ?? ""
                        
                        self.printErrorResponse(requestUrl, response, error, alertMsg: alertMsg)
                        
                        let localDesc = (error as NSError).localizedDescription
                        let errorCode = (error as NSError).code
                        let statusCode = response.response?.statusCode ?? nil
                        let err: APIError = APIError(statusCode: statusCode, errorCode: errorCode, localDesc: localDesc, alertMsg: alertMsg)
                        FirebaseCrashManager.recordError(err, api: url, method: method)
                        single(.error(err))
                    }
                })
            return Disposables.create()
        }
    }
    
    private func getEncodeWith(method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
          
        case .post:
            return JSONEncoding.default
            
        default:
            return URLEncoding.default
        }
    }
    
    private func getHttpHeadersWith(method: HTTPMethod, appendHeaders: [String: String]?) -> HTTPHeaders{
        let uuid = AccountRepository.shared.osUUID
        let appVersion = DeviceUtil.appBuildVersion()
        let osVersion = DeviceUtil.osVersion()
        let apiToken = AccountRepository.shared.getLocalApiToken() ?? ""
        let accessToken = MemberRepository.shared.getLocalAccessToken() ?? ""
        
        var headers: HTTPHeaders = [
            "Client_Id": "IOS",
            "Device_Id": uuid,
            "App_Version": appVersion!,
            "API_Token": apiToken,
            "OS_Version": osVersion!
        ]
        
        appendHeaders?.forEach({ header in
            headers[ header.key ] =  header.value
        })
        
        headers["Access_Token"]  = accessToken
        
        switch method {
        case .get:
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        case .post:
            headers["Content-Type"] = "application/json"
        default:
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        }
        
        return headers
    }
    
    private func getRequestUrlWith(url: APIUrl, appendUrl: String) -> String {
        let encodeUrl = appendUrl
        var requestUrl = ""
        
        switch url {
        case .authApi(let type):
            requestUrl = type.url()
        case .portalApi(let type):
            requestUrl = type.url()
        case .bulletinApi(let type):
            requestUrl = type.url()
        case .memberApi(let type):
            requestUrl = type.url()
        case .mainApi(let type):
            requestUrl = type.url()
        case .serviceApi(let type):
            requestUrl = type.url()
        case .noticeApi(let type):
            requestUrl = type.url()
        }

        requestUrl =  (requestUrl + encodeUrl ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return requestUrl
    }
    
    func cancelAllRequest () {
        self.printLog(value: "cancel All Request")
        requestManager.session.getTasksWithCompletionHandler {
            (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
}

extension APIManager {
    func getApiToken(deviceName: String, accessToken: String) -> Single<[String:Any]> {
        let params = ["Device_Name":deviceName,
                      "Access_Secret":accessToken]
        
        return manager(method: .post, appendUrl: "", url: APIUrl.authApi(type: .apiToken), parameters: params, appendHeaders: nil)
    }
    
    func pushDevice() -> Single<[String:Any]> {
        let params = ["Push_Id": AccountRepository.shared.getLocalFirebaseToken()!]
        
        return manager(method: .post, appendUrl: "", url:
            APIUrl.authApi(type: .pushDevice), parameters: params, appendHeaders: nil)
    }
    
    func getNoticeUnreadCount() -> Single<[String:Any]> {
        
        return manager(method: .get, appendUrl: "", url: APIUrl.noticeApi(type: .unreadCount) ,parameters: nil, appendHeaders: nil)
    }
    
    func getVersionRule() -> Single<[String:Any]> {
        return manager(method: .get, appendUrl: "", url: APIUrl.authApi(type: .versionRule), parameters: nil, appendHeaders: nil)
    }
    
    func getBulletin() -> Single<[String:Any]> {
        let appendUrl = ""
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.bulletinApi(type: .bulletin), parameters: nil, appendHeaders: nil)
    }
    
    func getRefreshToken(loginRequest: LoginRequest) -> Single<[String:Any]> {
        let params = ["Member_Idno":loginRequest.memberIdno!,
                      "Password":loginRequest.password!]
        return manager(method: .post, appendUrl: "", url: APIUrl.authApi(type: .refreshToken), parameters: params, appendHeaders: nil)
    }
    
    func getAccessToken(refreshToken:String) -> Single<[String:Any]> {
        let params = ["Refresh_Token":refreshToken]
        return manager(method: .post, appendUrl: "", url: APIUrl.authApi(type: .accessToken), parameters: params, appendHeaders: nil)
    }
    
    func getAccessWeb(webUrl:String) -> Single<[String:Any]> {
           let params = ["Web_Url":webUrl]
           return manager(method: .post, appendUrl: "", url: APIUrl.authApi(type: .accessWeb), parameters: params, appendHeaders: nil)
    }
    
    func memberLogout() -> Single<[String:Any]> {
        return manager(method: .post, appendUrl: "", url: APIUrl.authApi(type: .logout), parameters: nil, appendHeaders: nil)
    }
    
    func getMemberIndex()-> Single<[String:Any]> {
        
        return manager(method: .get, appendUrl: "", url: APIUrl.memberApi(type: .memberIndex), parameters: nil, appendHeaders: nil)
    }
    
    func passwordModify(passwordModifyRequest: PasswordModifyRequest) -> Single<[String: Any]> {
        let params = ["Original_Password": passwordModifyRequest.originalPassword,
                      "New_Password": passwordModifyRequest.newPassword,
                      "Confirm_New_Password": passwordModifyRequest.checkNewPassword,
                      "Password_Hint": passwordModifyRequest.passwordHint,
                      "Refresh_Token": passwordModifyRequest.refreshToken]
        return manager(method: .post, appendUrl: "", url: APIUrl.memberApi(type: .passwordModify), parameters: params as [String : Any], appendHeaders: nil)
    }
    
    func getGroupIndex(tourType:TourType) -> Single<[String:Any]> {
        
        return manager(method: .get, appendUrl: "", url: tourType.getApiUrl(), parameters: nil, appendHeaders: nil)
    }
    
    func getGroupMenu(toolBarType: ToolBarType)-> Single<[String:Any]> {
        
        return manager(method: .get, appendUrl: "", url: toolBarType.getApiUrl(), parameters: nil, appendHeaders: nil)
    }
    
    func getGroupTourSearchInit(departureCode: String?) -> Single<[String: Any]> {

        let appendUrl = ( departureCode == nil ) ? "" : "?Departure_Code=\(departureCode!)"
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.mainApi(type: .tourSearchInit), parameters: nil, appendHeaders: nil)
    }
    
    func getGroupTourSearchUrl(groupTourSearchRequest: GroupTourSearchRequest) -> Single<[String: Any]> {
        
        return manager(method: .post, appendUrl: "", url: APIUrl.mainApi(type: .tourSearch), parameters: groupTourSearchRequest.getDictionary(), appendHeaders: nil)
    }
    
    func getGroupTourSearchUrl(groupTourSearchKeywordAndTourCodeRequest: GroupTourSearchKeywordAndTourCodeRequest) -> Single<[String: Any]> {

        return manager(method: .post, appendUrl: "", url: APIUrl.mainApi(type: .tourKeywordSearch), parameters: groupTourSearchKeywordAndTourCodeRequest.getDictionary(), appendHeaders: nil)
    }

    func getMessageSendUserList(messageSendType: String) -> Single<[String:Any]> {
        
        var appendUrl = ""
        appendUrl = "/Initial?Send_Type=\(messageSendType)"
        
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.serviceApi(type: .messageSend), parameters: nil, appendHeaders: nil)
    }
    
    func messageSend(messageSendRequest: MessageSendRequest) -> Single<[String:Any]> {
        
        let params = ["Send_Type": messageSendRequest.sendType!,
                      "Send_Key_List": messageSendRequest.sendKeyList!,
                      "Message_Topic": messageSendRequest.messageTopic!,
                      "Message_Text": messageSendRequest.messageText!] as [String : Any]
        
        return manager(method: .post, appendUrl: "", url: APIUrl.serviceApi(type: .messageSend), parameters: params, appendHeaders: nil)
    }
    
    func getSalesList() -> Single<[String:Any]> {
        return manager(method: .get, appendUrl: "", url: APIUrl.portalApi(type: .serviceTourWindowList), parameters: nil, appendHeaders: nil)
    }

    func getNoticeList(pageIndex: Int) -> Single<[String:Any]> {
        let pageSize = "PageSize=30"
        var appendUrl = ""
        appendUrl = "PageIndex=" + "\(String(pageIndex))" + "&" + pageSize
        
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.noticeApi(type: .notice), parameters: nil, appendHeaders: nil)
    }
    
    func getGroupNewsList(pageIndex: Int) -> Single<[String:Any]> {
        let pageSize = "Page_Size=30"
        var appendUrl = ""
        appendUrl = "Page_Index=" + "\(String(pageIndex))" + "&" + pageSize
        
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.noticeApi(type: .groupNews), parameters: nil, appendHeaders: nil)
    }
    
    func getAirNewsList(pageIndex: Int) -> Single<[String:Any]> {
        let pageSize = "Page_Size=30"
        var appendUrl = ""
        appendUrl = "Page_Index=" + "\(String(pageIndex))" + "&" + pageSize
        
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.noticeApi(type: .airNews), parameters: nil, appendHeaders: nil)
    }
    
    func getImportantList(pageIndex: Int) -> Single<[String:Any]> {
        let pageSize = "PageSize=30"
        var appendUrl = ""
        appendUrl = "PageIndex=" + "\(String(pageIndex))" + "&" + pageSize
        
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.noticeApi(type: .important), parameters: nil, appendHeaders: nil)
    }
    
    func setNotiRead(notiId:[String])-> Single<[String:Any]> {
        let notiIdLists = notiId.map { (
            ["Noti_Id": $0
                ] as [String: Any])
        }
        
        let params = [
            "Noti_Status": "已讀",
            "NotiId_List": notiIdLists] as [String : Any]
        
        return manager(method: .post, appendUrl: "", url: APIUrl.noticeApi(type: .setNotiRead), parameters: params, appendHeaders: nil)
    }
    
    func getContactInfo() -> Single<[String: Any]> {
        return manager(method: .get, appendUrl: "", url: APIUrl.serviceApi(type: .contactInformation), parameters: nil, appendHeaders: nil)
    }
    
    func getWebViewTourShareList(tourCode:String,tourDate:String) -> Single<[String:Any]> {
        var appendUrl = ""
        appendUrl = "?Tour_Code=\(tourCode)&Tour_Date=\(tourDate)"
        return manager(method: .get, appendUrl: appendUrl, url: APIUrl.portalApi(type: .tourShare), parameters: nil, appendHeaders: nil)
    }
    
    func getAirSearchInit() -> Single<[String: Any]> {
        return manager(method: .get, appendUrl: "", url: APIUrl.mainApi(type: .airTktSearchInit), parameters: nil, appendHeaders: nil)
    }
    
    func getSotoSearchInit() -> Single<[String: Any]> {
        return manager(method: .get, appendUrl: "", url: APIUrl.mainApi(type: .sotoAirSearchInit), parameters: nil, appendHeaders: nil)
    }
    
    func postAirTicketSearch(request:TKTSearchRequest) -> Single<[String: Any]>  {
        let params = request.getDictionary()
        return manager(method: .post, appendUrl: "", url: APIUrl.mainApi(type: .airTicketSearchUrl), parameters: params, appendHeaders: nil)
    }
    
    func postSotoTicketSearch(request:SotoTicketRequest) -> Single<[String: Any]>  {
        let params = request.getDictionary()
        return manager(method: .post, appendUrl: "", url: APIUrl.mainApi(type: .airTicketSearchUrl), parameters: params, appendHeaders: nil)
    }
    
    func getLccSearchInit() -> Single<[String: Any]> {
        return AppHelper.shared.getJson(forResource: "TKTSearchInit")
    }
}

extension APIManager {
    
    private func printRequest(_ requestUrl: String, _ headers: HTTPHeaders, _ params: [String: Any]) {
        //return
        #if DEBUG
        print("-------------------------------------------------------")
        print("* 【呼叫】 The_requestUrl : \(requestUrl)")
        print("* 【呼叫】 Req∂uest_headers : ")
        headers.forEach({ header in
            print("   \(header)")
        })

        print("* 【呼叫】 Request_params : ")
        print(params)
        print(getPrettyParams(params) ?? "")
        #endif
    }
    
    private func printResponse(_ requestUrl: String,_ value: (Any)) {
        //return
        #if DEBUG
        print("-------------------------------------------------------")
        print("* 【回應】 The_requestUrl : \(requestUrl)")
        print("* 【回應】 Response_value : ")
        print(getPrettyPrint(value))
        #endif
    }
    
    private func printErrorResponse(_ requestUrl:String, _ response: (DataResponse<Any>), _ error: (Error), alertMsg: String) {
        //return
        #if DEBUG
        print("-------------------------------------------------------")
        print("* 【回應錯誤】 The_requestUrl : \(requestUrl)")
        print("* StatusCode : \(String(describing: response.response?.statusCode))")
        print("* View_OnError : \(String(describing:error))")
        print("* Error.code : \((error as NSError).code)")
        print("* AlertMsg : \(alertMsg)")
        #endif
    }
    
    private func printLog(value:String){
        #if DEBUG
        print("-------------------------------------------------------")
        print("****** \(value) ******")
        print("****** \(value) ******")
        print("****** \(value) ******")
        print("-------------------------------------------------------")
        #endif
    }
    
    private func getPrettyPrint(_ responseValue: Any) -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
    
    private func getPrettyParams(_ dict: [String: Any]) -> NSString? {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    }
}
