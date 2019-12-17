//
//  GoogleAPIManager.swift
//  colatour
//
//  Created by M7268 on 2019/3/20.
//  Copyright © 2019 Colatour. All rights reserved.
//


import RxSwift
import Alamofire
import Reachability
import CoreLocation
import RxCocoa

class GoogleAPIManager: NSObject {
    static let shared = GoogleAPIManager()
    let reachability = Reachability()!
    var isReachable = Variable(true)
    
    private var progress:Progress!
    private var context = 0
    
    lazy var requestManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APITimeout
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        #if COLATOUR_DEV
        let policies: [String: ServerTrustPolicy] = [:]
        return Alamofire.SessionManager(
            configuration: config,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies)
        )
        #endif
        
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
    
    
}

extension GoogleAPIManager {
    func getGeocode(address: String) -> Single<[String:Any]> {
        let appendUrl = "address=\(address)&key=\(googleApiKey)"
        return googleApiManager(method: .get, appendUrl: appendUrl, url: APIUrl.googleApi(type: .geocode) ,parameters: nil, appendHeaders: nil)
    }
    
    func getAutocomplete(textInput: String, sessionToken: String) -> Single<[String:Any]> {
        let appendUrl = "input=\(textInput)&language=ZH-TW&key=\(googleApiKey)&sessiontoken=\(sessionToken)"
        return googleApiManager(method: .get, appendUrl: appendUrl, url: APIUrl.googleApi(type: .autocomplete) ,parameters: nil, appendHeaders: nil)
    }
    
    func getPlaceIdGeocode(placeId: String, fields: String, sessionToken: String) -> Single<[String:Any]> {
        let appendUrl = "placeid=\(placeId)&fields=\(fields)&key=\(googleApiKey)&sessiontoken=\(sessionToken)"
        return googleApiManager(method: .get, appendUrl: appendUrl, url: APIUrl.googleApi(type: .placeIdGeocode) ,parameters: nil, appendHeaders: nil)
    }

}

extension GoogleAPIManager {
    private func printRequest(_ requestUrl: String, _ headers: HTTPHeaders, _ params: [String: Any]) {
        //return
        #if DEBUG
        print("@@@@@@@@@@@@@@@@呼叫開始@@@@@@@@@@@@@@@@")
        print("-----------------------------------")
        print("* requestUrl : ")
        print("   \(requestUrl)")
        print("-----------------------------------")
        print("* headers : ")
        
        headers.forEach({ header in
            print("   \(header)")
        })
        print("-----------------------------------")
        print("* params : ")
        //print(params)
        print(getPrettyParams(params) ?? "")
        print("-----------------------------------")
        print("@@@@@@@@@@@@@@@@呼叫結束@@@@@@@@@@@@@@@@")
        #endif
    }
    
    private func printResponse(_ requestUrl: String,_ value: (Any)){
        //return
        #if DEBUG
        print("################回應開始################")
        print("-----------------------------------")
        print("* The requestUrl : ")
        print("   \(requestUrl)")
        print("* Response_value : ")
        print(getPrettyPrint(value))
        print("-----------------------------------")
        print("################回應結束################")
        #endif
    }
    
    private func printErrorResponse(_ requestUrl:String, _ response: (DataResponse<Any>), _ error: (Error)) {
        //return
        #if DEBUG
        print("################回應錯誤開始################")
        print("-----------------------------------")
        print("* The requestUrl : ")
        print("   \(requestUrl)")
        print("* StatusCode : ")
        print("   \(String(describing: response.response?.statusCode))")
        print("* View_OnError : ")
        print("   \(String(describing:error))")
        print("* Error.code : ")
        print("   \((error as NSError).code)")
        print("-----------------------------------")
        print("################回應結束################")
        #endif
    }
    
    private func getPrettyPrint(_ responseValue: Any) -> String{
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted){
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                string = nstr as String
            }
        }
        return string
    }
    
    private func getPrettyParams(_ dict: [String: Any]) -> NSString? {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    }
    
    fileprivate func googleApiManager(method: HTTPMethod, appendUrl: String, url: APIUrl, parameters: [String: Any]?, appendHeaders: [String: String]?) -> Single<[String:Any]> {
        
        let param = (parameters) ?? [String:Any]()
        return Single.create { (single) -> Disposable in
            
            var encode: ParameterEncoding?
            switch method {
            case .get:
                encode = URLEncoding.default
            case .post:
                encode = JSONEncoding.default
            default:
                encode = URLEncoding.default
            }
            
            if (self.isReachable.value == false) {
                let err = APIError.init(type: .noInternetException, localDesc: "The Internet connection appears to be offline.", alertMsg: "")
                single(.error(err))
                FirebaseCrashManager.recordError(err, api: url, method: method)
                return Disposables.create()
            }
            var requestUrl = ""
            let encodeUrl = appendUrl
            switch url {
            case .authApi(let type):
                requestUrl = type.url()
            case .portalApi(let type):
                requestUrl = type.url()
            case .bulletinApi(let type):
                requestUrl = type.url()
            case .ticketApi(let type):
                requestUrl = type.url()
            case .memberApi(let type):
                requestUrl = type.url()
            case .paymentApi(let type):
                requestUrl = type.url()
            case .notificationApi(let type):
                requestUrl = type.url()
            case .googleApi(let type):
                requestUrl = type.url()
            case .eTicketApi(let type):
                requestUrl = type.url()
            case .pureUrlApi(let type):
                requestUrl = type.url()
            case .hotelApi(let type):
                requestUrl = type.url()
            }
            
            requestUrl =  (requestUrl + encodeUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            self.requestManager
                .request(requestUrl, method: method, parameters: param, encoding: encode!, headers: nil)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        if (value is [String:Any]) {
                            self.printResponse(requestUrl, value)
                            single(.success(value as! [String:Any]))
                        } else {
                            let err = APIError.init(type: .otherException, localDesc: "It's success.But AlertMsg doesn't exist.", alertMsg: "")
                            self.printErrorResponse(requestUrl, response, err)
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
                        
                        self.printErrorResponse(requestUrl, response, error)
                        
                        let localDesc = (error as NSError).localizedDescription
                        let errorCode = (error as NSError).code
                        let statusCode = response.response?.statusCode ?? nil
                        let err = APIError(statusCode: statusCode, errorCode: errorCode, localDesc: localDesc, alertMsg: alertMsg)
                        FirebaseCrashManager.recordError(err, api: url, method: method)
                        single(.error(err))
                    }
                })
            return Disposables.create()
        }
    }
}
