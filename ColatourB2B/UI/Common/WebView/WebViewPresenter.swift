//
//  WebViewPresenter.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/2/26.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift
import UIKit
import ObjectMapper

class WebViewPresenter: WebViewPresenterProtocol {
    weak var delegate: WebViewProtocol?
    fileprivate var dispose = DisposeBag()
    let accountRepositouy = AccountRepository.shared
    
    convenience init(delegate: WebViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getTourShareList(tourCode: String, tourDate: String) {
        accountRepositouy.getWebViewTourShareList(tourCode: tourCode, tourDate: tourDate).subscribe(onSuccess: { (model) in
            self.delegate?.onBindTourShareList(shareList: model)
        }, onError: { (error) in
            ()
        }).disposed(by: dispose)
    }
}
