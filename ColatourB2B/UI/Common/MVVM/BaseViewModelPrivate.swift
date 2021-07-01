//
//  BaseViewModelPrivate.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/5/28.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModelPrivate: BaseViewModel {
    
    static let share = BaseViewModelPrivate()
    
    private var dispose = DisposeBag()
    override init() {
        print("BaseViewModelPrivate didInit")
    }
    func getAccessToken(linkType: LinkType?, linkValue: String?){
        self.onStartLoadingHandle?(.ignore)
        
        AccountRepository.shared.getAccessToken(getLocalToken:false).subscribe(onSuccess: { [weak self ](_) in
            
            if linkType != nil {
                self?.onBindAccessTokenByLink?(linkType!, linkValue)
            }
            self?.loadData?()
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?(error as! APIError, .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getAccessWebUrl(webUrl:String, title: String, openBrowserOrAppWebView: OpenBrowserOrAppWebView) {
        
        self.onStartLoadingHandle?(.ignore)
        AccountRepository.shared.getAccessWeb(webUrl: webUrl).subscribe(onSuccess: { [weak self] (url) in
            self?.onBindAccessWebUrl?(url, title, openBrowserOrAppWebView)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?(error as! APIError, .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
}
