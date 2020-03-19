//
//  BasePresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import RxSwift

class BasePresenter: NSObject,BasePresenterProtocol {
    
    let dispose = DisposeBag()
    weak var delegate: BaseViewProtocol?
    
    override init(){
        super.init()
    }
    
    convenience init(delegate: BaseViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getAccessToken(linkType: LinkType?, linkValue: String?){
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        AccountRepository.shared.getAccessToken(getLocalToken:false).subscribe(onSuccess: { (_) in
            
            if linkType != nil {
                self.delegate?.onBindAccessToken(linkType: linkType!, linkValue: linkValue)
            }
            self.delegate?.loadData()
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func getAccessWebUrl(webUrl:String, title: String, openBrowserOrAppWebView: OpenBrowserOrAppWebView) {
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        AccountRepository.shared.getAccessWeb(webUrl: webUrl).subscribe(onSuccess: { (url) in
            self.delegate?.onBindAccessWebUrl(url: url, title: title, openBrowserOrAppWebView: openBrowserOrAppWebView)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
}