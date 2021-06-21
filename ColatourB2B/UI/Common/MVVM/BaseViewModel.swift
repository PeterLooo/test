//
//  BaseViewModel.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/5/28.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    var onStartLoadingHandle: ((APILoadingHandleType) -> ())?
    var onCompletedLoadingHandle: (() -> ())?
    var onApiErrorHandle: ((APIError,APIErrorHandleType) -> ())?
    var handleLinkType: ((_ linkType: LinkType, _ linkValue: String?, _ linkText: String?, _ source: String? ) -> ())?
    var loadData: (() -> ())?
    var onBindAccessWebUrl: ((_ url: String,_ title: String,_ openBrowserOrAppWebView: OpenBrowserOrAppWebView)->())?
    var onBindAccessTokenByLink:((_ linkType: LinkType,_ linkValue: String?)->())?
    
}
