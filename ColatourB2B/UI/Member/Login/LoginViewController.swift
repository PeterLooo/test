//
//  LoginViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
extension LoginViewController {
    func setVC(viewModel: LoginViewModel){
        self.viewModel = viewModel
    }
}
protocol MemberLoginOnTouchNavCloseProtocol : NSObjectProtocol{
    func onTouchLoginNavClose()
}
class LoginViewController: BaseViewController {
    
    @IBOutlet weak var memberIdno: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var register: UIButton!
    
    weak var navCloseDelegate: MemberLoginOnTouchNavCloseProtocol?
    
    var viewModel: LoginViewModel?
    
    private var linkType: LinkType?
    private var linkValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarItem(left: .custom, mid: .textTitle, right: .nothing)
        self.setIsNavShadowEnable(false)
        self.setTabBarType(tabBarType: .hidden)
        self.register.layer.borderColor = ColorHexUtil.hexColor(hex: "#19BF62").cgColor
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchScrollView(_:)))
        scrollView.addGestureRecognizer(ges)
        password.clearButton.isHidden = true
        memberIdno.someController?.placeholderText = "會員帳號"
        password.someController?.placeholderText = "密碼"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        memberIdno.addTarget(self, action: #selector(memberIdnoEdit), for: .editingChanged)
        password.addTarget(self, action: #selector(passwordEdit), for: .editingChanged)
        bindViewModel()
    }
    
    @objc func memberIdnoEdit(){
        viewModel?.memberIdno = memberIdno.text
        memberIdno.someController?.setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    @objc func passwordEdit(){
        viewModel?.password = password.text
        password.someController?.setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        password.text = ""
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.05, animations: {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.cgRectValue.height + 25, right: 0)
            }
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.05, animations: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
    
    @objc private func onTouchScrollView(_ sender: UIScrollView) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTouchLogin(_ sender: UIButton) {
        viewModel?.login()
    }
    
    @IBAction func onTouchRegister(_ sender: Any) {
        
        let vc = self.getVC(st: "Register", vc: "RegisterNoticeViewController") as! RegisterNoticeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTouchEyes(_ sender: BooleanButton) {
        password.isSecureTextEntry = sender.isSelect
    }
    
    private func bindViewModel(){
        
        viewModel?.dismissLoginView = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.viewModel?.loginSuccessAction()
            })
        }
        
        viewModel?.presentModifyVC = { [weak self] accessToken, refreshToken, message in
            let vc = self?.getVC(st: "PasswordModify", vc: "PasswordModify") as! PasswordModifyViewController
            vc.setVC(accessToken: accessToken,
                     refreshToken: refreshToken,
                     loginMessage: message)
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel?.setToastText = { [weak self] text in
            self?.view.endEditing(true)
            self?.toast(text: text)
        }
        
        viewModel?.setTextFieldErrorInfo = { [weak self] errorId, errorPassword in
            if errorPassword != nil {
                self?.password.someController?.setErrorText(errorPassword!, errorAccessibilityValue: nil)
                self?.password.becomeFirstResponder()
            }
            if errorId != nil {
                self?.memberIdno.someController?.setErrorText(errorId!, errorAccessibilityValue: nil)
                self?.memberIdno.becomeFirstResponder()
            }
        }
    }
}

extension LoginViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.view.endEditing(true)
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == memberIdno {
            self.password.becomeFirstResponder()
        }
        if textField == password {
            self.onTouchLogin(self.login)
        }
        return true
    }
}
