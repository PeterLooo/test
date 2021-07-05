//
//  ChangeCompanyViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import RxSwift

class ChangeCompanyViewModel: BaseViewModel {
    
    var reloadTableView: (()->())?
    
    let respository = MemberRepository.shared
    
    var changeModel: ChangeCompanyModel?
    
    private let disposeBag = DisposeBag()
    
    func getChangeCompanyInfo() {
        self.onStartLoadingHandle?(.coverPlate)
        
        respository.getChangeCompany().subscribe { [weak self] model in
            self?.changeModel = model
            self?.reloadTableView?()
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError,.coverPlate)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    private func postChangeCompany(){
        self.onStartLoadingHandle?(.coverPlateAlpha)
        respository.postChangeCompany(model: changeModel!).subscribe {[weak self] model in
            print(model)
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError , .alert)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func onTouchConfirm(){
        checkTextField { [weak self] errorInfo in
            if errorInfo != nil {
                self?.changeModel?.errorInfo = errorInfo
                self?.reloadTableView?()
                return
            }
        }
        postChangeCompany()
    }
    
    func checkTextField(completed: @escaping (ChangeCompanyErrorModel?) ->()){
        let errorInfo = ChangeCompanyErrorModel()
        var noEmptyInfo = true
        if changeModel?.newCompanyId.isNilOrEmpty == true {
            errorInfo.newCompanyId = "請輸入新旅行社統編"
            noEmptyInfo = false
        }
        if changeModel?.newCompanyName.isNilOrEmpty == true {
            errorInfo.newCompanyName = "請輸入新旅行社公司名"
            noEmptyInfo = false
        }
        if changeModel?.email.isNilOrEmpty == true {
            errorInfo.email = "請輸入Email"
            noEmptyInfo = false
        }
        if changeModel?.phoneNo.isNilOrEmpty == true && changeModel?.phoneZone.isNilOrEmpty == true {
            errorInfo.phone = "請輸入區碼與公司電話"
            noEmptyInfo = false
        } else if changeModel?.phoneZone.isNilOrEmpty == true {
            errorInfo.phone = "請輸入區碼"
            noEmptyInfo = false
        } else if changeModel?.phoneNo.isNilOrEmpty == true {
            errorInfo.phone = "請輸入公司電話"
            noEmptyInfo = false
        }
        
        if changeModel?.mobile.isNilOrEmpty == true {
            errorInfo.mobile = "請輸入手機號碼"
            noEmptyInfo = false
        }
        
        if noEmptyInfo == false {
            
            completed(errorInfo)
        }else{
            completed(nil)
        }
    }
}
