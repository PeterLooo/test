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
    var setMemberErrorInfo: (([ErrorInfo]) -> ())?
    var changeCompanySuccessfully: (()->())?
    var toastInfo: ((String)->())?
    let respository = MemberRepository.shared
    
    var changeCompanyModel: ChangeCompanyModel?
    var changeMemberInfo: ChangeMemberInfo?
    
    private let disposeBag = DisposeBag()
    
    func getChangeCompanyInfo() {
        self.onStartLoadingHandle?(.coverPlate)
        
        respository.getChangeCompany().subscribe { [weak self] model in
            self?.changeCompanyModel = model
            self?.reloadTableView?()
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError,.coverPlate)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    private func postChangeCompany(){
        self.onStartLoadingHandle?(.coverPlateAlpha)
        respository.postChangeCompany(model: changeCompanyModel!).subscribe {[weak self] model in
            self?.bindingChangeCompany(result: model)
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError , .alert)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func changeMemberInfoInit() {
        self.onStartLoadingHandle?(.coverPlate)
        respository.changeMemberInfoInit().subscribe { [weak self] model in
            self?.changeMemberInfo = model.memberInfo
            self?.reloadTableView?()
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError,.coverPlate)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func changeMemberAction(){
        self.onStartLoadingHandle?(.coverPlateAlpha)
        respository.changeMemberInfo(changeMember: changeMemberInfo!).subscribe { [weak self] model in
            self?.bindChangeMemberData(result: model)
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError,.coverPlate)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func onTouchConfirm(editMode: ChangeCompanyViewController.MemberEdit){
        switch editMode {
        case .company:
            checkTextField { [weak self] errorInfo in
                if errorInfo.isEmpty == false {
                    self?.changeCompanyModel?.errorInfo = errorInfo
                    self?.reloadTableView?()
                    return
                }else{
                    self?.postChangeCompany()
                }
            }
            
        case .memberInfo:
            if checkMemberFieldEmpty() {
                changeMemberAction()
            }
        }
    }
    
    func bindingChangeCompany(result: ChangeCompanyModel) {
        if result.errorInfo.isEmpty {
            self.changeCompanySuccessfully?()
        }else{
            self.changeCompanyModel?.errorInfo = result.errorInfo
            self.reloadTableView?()
        }
    }
    
    func bindChangeMemberData(result: MemberData) {
        if result.emailError == true{
            self.toastInfo?("Email錯誤")
        }else if result.errorList.isEmpty == false {
            self.setMemberErrorInfo?(result.errorList)
        }else{
            self.toastInfo?("會員資料修改完畢")
        }
    }
    
    func checkTextField(completed: @escaping ([ErrorInfo]) ->()){
        var errorList : [ErrorInfo] = []
        
        if changeCompanyModel?.newCompanyId.isNilOrEmpty == true {
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入新旅行社統編"
            errorInfo.columnName = "New_Company_Idno"
            errorList.append(errorInfo)
        }
        if changeCompanyModel?.newCompanyName.isNilOrEmpty == true {
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入新旅行社公司名"
            errorInfo.columnName = "New_Company_Name"
            errorList.append(errorInfo)
        }
        if changeCompanyModel?.email.isNilOrEmpty == true {
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入Email"
            errorInfo.columnName = "Member_Email"
            errorList.append(errorInfo)
        }
        if changeCompanyModel?.phoneNo.isNilOrEmpty == true || changeCompanyModel?.phoneZone.isNilOrEmpty == true {
            
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入區碼與公司電話"
            errorInfo.columnName = "Company_Phone_No"
            errorList.append(errorInfo)
        }
        
        if changeCompanyModel?.mobile.isNilOrEmpty == true {
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入手機號碼"
            errorInfo.columnName = "Mobile_Phone"
            errorList.append(errorInfo)
        }
        
        completed(errorList)
    }
    
    func checkMemberFieldEmpty() -> Bool {
        var errorList : [ErrorInfo] = []
    
        if changeMemberInfo?.birthday?.isEmpty == true {
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入生日"
            errorInfo.columnName = "Member_Birthday"
            errorList.append(errorInfo)
        }
        if changeMemberInfo?.email?.isEmpty == true {
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入Email"
            errorInfo.columnName = "Member_Email"
            errorList.append(errorInfo)
        }
        if changeMemberInfo?.mobile?.isEmpty == true {
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入行動電話"
            errorInfo.columnName = "Mobile_Phone"
            errorList.append(errorInfo)
        }
        if changeMemberInfo?.phoneNo.isNilOrEmpty == true || changeMemberInfo?.phoneZone.isNilOrEmpty == true{
            let errorInfo = ErrorInfo()
            errorInfo.errorMessage = "請輸入公司電話或區碼"
            errorInfo.columnName = "Company_Phone_No"
            errorList.append(errorInfo)
        }
        if errorList.isEmpty == false {
            self.changeMemberInfo?.errorList = errorList
            setMemberErrorInfo?(errorList)
            return false
        }
        
        return true
    }
}
