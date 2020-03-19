//
//  MoreProtocol.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/3.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import RxSwift

class MorePresenter: MorePresenterProtocol {
    weak var delegate: MoreViewProtocol?
    let groupRepository = GroupReponsitory.shared
    var disposeBag = DisposeBag()
    
    convenience init(delegate: MoreViewProtocol) {
        self.init()
        self.delegate = delegate
    }

    func getOtherToolBarList() {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlateAlpha)
        groupRepository
            .getGroupMenu(toolBarType: .other)
            .subscribe(onSuccess: { model in
                let serverList = model.serverList.flatMap{($0)}
                self.delegate?.onBindOtherToolBarList(toolBarList: serverList)
                self.delegate?.onCompletedLoadingHandle()
            }, onError: { error in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
                self.delegate?.onCompletedLoadingHandle()
            }).disposed(by: disposeBag)
    }
}
