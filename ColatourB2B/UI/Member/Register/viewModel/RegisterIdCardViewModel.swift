//
//  RegisterIdCardViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/7.
//  Copyright © 2021 Colatour. All rights reserved.
//
import RxSwift

class RegisterIdCardViewModel: BaseViewModel {
    
    var title: String?
    var setError: ((String) -> ())?
    var pushToVC: ((UIViewController) -> ())?
    
    private var id: String?
    private var companyID: String?
    private var companyName: String?
    private let registerRepository = RegisterRepository.shared
    private var disposeBag = DisposeBag()
    
    func setViewModel(title: String, companyID: String, companyName: String) {
        self.title = title
        self.companyID = companyID
        self.companyName = companyName
    }
    
    func onTouchNext(id: String) {
        self.id = id
        self.id!.isEmpty == true ? setError?("請輸入\(self.title ?? "")") : getRegisterIdNo()
    }
}

extension RegisterIdCardViewModel {
    
    private func onBindIsRegister(model: RegisterIdNoModel) {
        
        if model.errorMessage.isNilOrEmpty == false {
            setError?(model.errorMessage ?? "")
        } else {
            let storyboard = UIStoryboard(name: "Register", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterBasicInfoViewController") as! RegisterBasicInfoViewController
            let viewModel = RegisterBasicInfoViewModel()
            viewModel.setViewModel(id: id ?? "", companyID: companyID ?? "", companyName: companyName ?? "")
            viewController.setVC(viewModel: viewModel)
            pushToVC?(viewController)
        }
    }
    
    private func getRegisterIdNo() {
        
        onStartLoadingHandle?(.coverPlate)
        
        registerRepository.getRegisterIdNo(idNo: id ?? "").subscribe(onSuccess: { [weak self] (model) in
            self?.onBindIsRegister(model: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: disposeBag)
    }
}
