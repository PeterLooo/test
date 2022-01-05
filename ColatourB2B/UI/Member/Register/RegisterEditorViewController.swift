//
//  RegisterEditorViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/11/25.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit

class RegisterEditorViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var editor: CustomTextField!
    @IBOutlet weak var editorInfo: UILabel!
    
    private var viewModel: RegisterEditorViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onBindViewModel()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "請輸入任職旅行社統編"
    }
    
    @IBAction func onTouchNext(_ sender: Any) {
        
        viewModel?.onTouchNext(companyIdno: editor.text ?? "")
    }
}

extension RegisterEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        viewModel?.onTouchNext(companyIdno: editor.text ?? "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.editor.someController?.setErrorText(nil, errorAccessibilityValue: nil)
        return true
    }
}

extension RegisterEditorViewController {
    
    private func onBindViewModel() {
        
        viewModel = RegisterEditorViewModel()
        bindToBaseViewModel(viewModel: viewModel!)
        
        viewModel?.setError = { [weak self] error in
            self?.editor.someController?.setErrorText(error, errorAccessibilityValue: nil)
            self?.editorInfo.isHidden = true
            self?.editor.resignFirstResponder()
        }
        viewModel?.pushToVC = { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setView() {
        
        self.editor.someController?.placeholderText = "＊任職旅行社統編"
        self.editor.delegate = self
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyBoard))
        view.addGestureRecognizer(ges)
    }
    
    @objc func dimissKeyBoard() {
        self.editor.endEditing(true)
    }
}
