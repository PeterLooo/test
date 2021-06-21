//
//  BaseViewControllerMVVM.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/5/28.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import UIKit

class BaseViewControllerMVVM: BaseViewController {
    private let baseViewModelPrivate = BaseViewModelPrivate.share
    
    func bindToBaseViewModel(viewModel: BaseViewModel) {
        
        viewModel.onCompletedLoadingHandle = { [weak self] in
            self?.onCompletedLoadingHandle()
        }
        viewModel.onStartLoadingHandle = { [weak self] handleType in
            self?.onStartLoadingHandle(handleType: handleType)
        }
        
        viewModel.handleLinkType = { [weak self] linkType, linkValue, linkText, source in
            self?.handleLinkType(linkType: linkType, linkValue: linkValue, linkText: linkText, source: source)
        }
        
        baseViewModelPrivate.loadData = { [weak self] in
            self?.loadData()
        }
        
        baseViewModelPrivate.onBindAccessTokenByLink = { [weak self] linkType, linkValue in
            self?.handleLinkType(linkType: linkType, linkValue: linkValue, linkText: "")
        }
        
        baseViewModelPrivate.onBindAccessWebUrl = { [weak self] url, title, openBrowserOrAppWebView in
            switch openBrowserOrAppWebView {
            case .openAppWebView:
                let vc = self?.getVC(st: "Common", vc: "WebViewController") as! WebViewController
                vc.setVCwith(url: url, title: title)
                vc.setDismissButton()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.restorationIdentifier = "WebViewControllerNavigationController"
                self?.present(nav, animated: true)
            case .openBrowser:
                self?.handleLinkType(linkType: .openBrowser, linkValue: url, linkText: title)
            }
        }
        
        viewModel.onApiErrorHandle = { [weak self] apiError, handleType in
            switch apiError.type {
            case .apiUnauthorizedException:
                AccountRepository.shared.removeLocalApiToken()
                
            case .noInternetException:
                self?.handleNoInternetError(handleType: handleType)
                
            case .apiForbiddenException:
                
                self?.baseViewModelPrivate.getAccessToken(linkType: self?.baseLinkType, linkValue: self?.baseLinkValue)
                
            case .apiFailException:
                self?.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg, isAlertWithContactService: true)
            case .apiFailForUserException:
                self?.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg, isAlertWithContactService: false)
            case .requestTimeOut:
                self?.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg, isAlertWithContactService: true)
            case .otherException:
                self?.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg, isAlertWithContactService: true)
            case .presentLogin:
                self?.logoutAndPopLoginVC()
            case .cancelAllRequestDoNothing:
                ()
            }
        }
    }
}
