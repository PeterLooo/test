//
//  BaseProtocol.swift
//  colatour
//HomeProtocol
//  Created by M6853 on 2018/1/23.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

protocol BaseViewProtocol: NSObjectProtocol {
    func onApiErrorHandle(apiError: APIError, handleType: APIErrorHandleType)
    func onStartLoadingHandle(handleType: APILoadingHandleType)
    func onCompletedLoadingHandle()
    func loadData()
    func onTouchService()
    func onBindAccessToken(response: AccessTokenResponse)
    func onBindAccessWebUrl(url: String, title: String, openBrowserOrAppWebView: OpenBrowserOrAppWebView)
}

protocol BasePresenterProtocol {

}
