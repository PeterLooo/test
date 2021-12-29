//
//  RegisterIdCardViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/11/29.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit

extension RegisterIdCardViewController {
    func setVC(viewModel: RegisterIdCardViewModel) {
        self.viewModel = viewModel
    }
}

class RegisterIdCardViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var id: CustomTextField!
    @IBOutlet weak var idInfo: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    private var viewModel: RegisterIdCardViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "請輸入\(viewModel?.title ?? "")"
        self.id.someController?.placeholderText = viewModel?.title ?? ""
    }
    
    @objc func dimissKeyBoard() {
        self.id.endEditing(true)
    }
    
    @IBAction func onTouchBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTouchNext(_ sender: Any) {
        
        viewModel?.onTouchNext(id: id.text ?? "")
    }
}

extension RegisterIdCardViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        viewModel?.onTouchNext(id: id.text ?? "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.id.someController?.setErrorText(nil, errorAccessibilityValue: nil)
        self.idInfo.isHidden = false
        return true
    }
}

extension RegisterIdCardViewController {
    
    private func bindViewModel() {
        
        bindToBaseViewModel(viewModel: viewModel!)
        
        viewModel?.setError = { [weak self] error in
            self?.id.someController?.setErrorText(error, errorAccessibilityValue: nil)
            self?.idInfo.isHidden = true
            self?.id.resignFirstResponder()
        }
        
        viewModel?.pushToVC = { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setView() {
        id.delegate = self
        backButton.layer.borderColor = ColorHexUtil.hexColor(hex: "#19BF62").cgColor
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyBoard))
        view.addGestureRecognizer(ges)
    }
}
