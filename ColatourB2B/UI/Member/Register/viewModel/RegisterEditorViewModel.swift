//
//  RegisterEditorViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/7.
//  Copyright © 2021 Colatour. All rights reserved.
//
import RxSwift

class RegisterEditorViewModel: BaseViewModel {
    
    var setError: ((String) -> ())?
    var pushToVC: ((UIViewController) -> ())?
    
    private var companyIdno: String?
    private var companyName: String?
    private let registerRepository = RegisterRepository.shared
    private var disposeBag = DisposeBag()
    
    func onTouchNext(companyIdno: String) {
        self.companyIdno = companyIdno
        if companyIdno.isEmpty {
            setError?("請輸入任職旅行社統編")
        }else {
            getEditorAgent()
        }
    }
    
    func getIdTitle() {
        
        onStartLoadingHandle?(.coverPlate)
        
        registerRepository.getIDTitle().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindIDTitle(model: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: disposeBag)
    }
}

extension RegisterEditorViewModel {
    
    private func getEditorAgent() {
        
        onStartLoadingHandle?(.coverPlate)
        
        registerRepository.getEditorAgent(companyIdno: companyIdno ?? "").subscribe(onSuccess: { [weak self] (model) in
            self?.onBindEditorAgent(model: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: disposeBag)
    }
    
    private func onBindEditorAgent(model: RegisterAgentModel) {
        
        if model.errorMessage.isNilOrEmpty == false {
            setError?(model.errorMessage ?? "")
        } else if model.agentIsExist == true {
            self.companyName = model.companyName
            getIdTitle()
        } else {
            
            let storyboard = UIStoryboard(name: "Register", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterCompanyViewController") as! RegisterCompanyViewController
            let viewModel = RegisterCompanyViewModel()
            viewModel.setViewModel(id: companyIdno ?? "")
            viewController.setVC(viewModel: viewModel)
            
            pushToVC?(viewController)
        }
    }
    
    private func onBindIDTitle(model: RegisterIdTitleModel) {
        let storyboard = UIStoryboard(name: "Register", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterIdCardViewController") as! RegisterIdCardViewController
        let viewModel = RegisterIdCardViewModel()
        viewModel.setViewModel(title: model.titleName ?? "", companyID: companyIdno ?? "", companyName: companyName ?? "")
        viewController.setVC(viewModel: viewModel)
        
        pushToVC?(viewController)
    }
}
