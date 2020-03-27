//
//  LoginViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
protocol MemberLoginSuccessViewProtocol : NSObjectProtocol{
    func onLoginSuccess()
    func onLoginSuccess(linkType: LinkType , linkValue: String? )
    func setDefaultTabBar()
}
protocol MemberLoginOnTouchNavCloseProtocol : NSObjectProtocol{
    func onTouchLoginNavClose()
}
class LoginViewController: BaseViewController {
    
    @IBOutlet weak var memberIdno: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var navCloseDelegate: MemberLoginOnTouchNavCloseProtocol?
    weak var loginSuccessDelegate: MemberLoginSuccessViewProtocol?
    
    private var presenter : LoginPresenterProtocol?
    private var linkType: LinkType?
    private var linkValue: String?
    
    required init?(coder:NSCoder) {
        super.init(coder: coder)
        presenter = LoginPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarItem(left: .custom, mid: .textTitle, right: .nothing)
        self.setIsNavShadowEnable(false)
        self.setTabBarType(tabBarType: .hidden)
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchScrollView(_:)))
        scrollView.addGestureRecognizer(ges)
        password.clearButton.isHidden = true
        memberIdno.someController?.placeholderText = "會員帳號"
        password.someController?.placeholderText = "密碼"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        if memberIdno.text?.count == 0 {
            memberIdno.someController?.setErrorText("請輸入會員帳號", errorAccessibilityValue: nil)
            memberIdno.becomeFirstResponder()
        } else if (password.text?.count)! == 0 {
            password.someController?.setErrorText("請輸入密碼", errorAccessibilityValue: nil)
            password.becomeFirstResponder()
        }else{
             let request = LoginRequest()
                   request.memberIdno = self.memberIdno.text
                   request.password = self.password.text
                   self.presenter?.login(requset: request)
        }
    }
    
    @IBAction func onTouchEyes(_ sender: BooleanButton) {
        password.isSecureTextEntry = sender.isSelect
    }
}

extension LoginViewController : LoginViewProtocol {
    func loginSuccess(loginResponse: LoginResponse) {
        if loginResponse.loginResult == false {
            if let resultMessage = loginResponse.loginMessage {
                self.view.endEditing(true)
                self.toast(text: resultMessage)
            }
        }else{
            self.loginSuccessDelegate?.setDefaultTabBar()
            presenter?.pushDevice()
            NotificationCenter.default.post(name: Notification.Name("noticeLoadDate"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            self.dismiss(animated: true, completion: {
                
                if let linkType = self.linkType{
                    self.loginSuccessDelegate?.onLoginSuccess(linkType: linkType, linkValue: self.linkValue)
                }else{
                    self.loginSuccessDelegate?.onLoginSuccess()
                }
            })
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case memberIdno:
            
            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
            memberIdno.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            return false
        case password:
            
            password.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            return true
        default:
            return false
        }
    }
}
