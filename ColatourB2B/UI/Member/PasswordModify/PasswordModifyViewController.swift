//
//  PasswordModifyViewController.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol PasswordModifyToastProtocol {
    
    func setPasswordModifyToastText(text: String)
}

class PasswordModifyViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var originalPassword: CustomTextField!
    @IBOutlet weak var newPassword: CustomTextField!
    @IBOutlet weak var checkNewPassword: CustomTextField!
    @IBOutlet weak var passwordHint: CustomTextField!
    @IBOutlet weak var originalPasswordEye: BooleanButton!
    @IBOutlet weak var newPasswordEye: BooleanButton!
    @IBOutlet weak var checkNewPasswordEye: BooleanButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var presenter: PasswordModifyPresenter?
    var delegate: PasswordModifyToastProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = PasswordModifyPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarItem(left: .defaultType, mid: .textTitle, right: .custom)
        setNavTitle(title: "更改密碼")
        setNavButton()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTouchScrollView))
        scrollView.addGestureRecognizer(gesture)
        
        scrollView.delegate = self
        
        originalPassword.someController?.placeholderText = "輸入原密碼"
        originalPassword.clearButton.isHidden = true
        originalPassword.delegate = self
        newPassword.someController?.placeholderText = "輸入新密碼"
        newPassword.clearButton.isHidden = true
        newPassword.delegate = self
        checkNewPassword.someController?.placeholderText = "新密碼確認"
        checkNewPassword.clearButton.isHidden = true
        checkNewPassword.delegate = self
        passwordHint.someController?.placeholderText = "密碼提示"
        passwordHint.clearButton.isHidden = true
        passwordHint.delegate = self
        
        hintLabel.isHidden = true
        
        confirmButton.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠"))
        
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
    
    @objc func onTouchScrollView(_ sender: UIScrollView) {
        
        self.view.endEditing(true)
    }
    
    @objc private func onTouchCancel(){
           
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTouchEyes(_ sender: BooleanButton) {
        
        switch sender {
            
        case originalPasswordEye:
            originalPassword.isSecureTextEntry = sender.isSelect
            
        case newPasswordEye:
            newPassword.isSecureTextEntry = sender.isSelect
            
        case checkNewPasswordEye:
            checkNewPassword.isSecureTextEntry = sender.isSelect
            
        default:
            return
        }
    }
    
    @IBAction func onTouchConfirm(_ sender: UIButton) {
        
        if originalPassword.text?.count == 0 {
            originalPassword.someController?.setErrorText("請輸入原密碼", errorAccessibilityValue: nil)
            originalPassword.becomeFirstResponder()
        
        } else if newPassword.text?.count == 0 {
            newPassword.someController?.setErrorText("請輸入新密碼", errorAccessibilityValue: nil)
            newPassword.becomeFirstResponder()
        
        } else if checkNewPassword.text?.count == 0 {
            checkNewPassword.someController?.setErrorText("請再一次輸入新密碼", errorAccessibilityValue: nil)
            checkNewPassword.becomeFirstResponder()
            
        } else if passwordHint.text?.count == 0 {
            passwordHint.someController?.setErrorText("", errorAccessibilityValue: nil)
            hintLabel.isHidden = false
            passwordHint.becomeFirstResponder()
            
        } else {
            let request = PasswordModifyRequest()
            request.originalPassword = originalPassword.text
            request.newPassword = newPassword.text
            request.checkNewPassword = checkNewPassword.text
            request.passwordHint = passwordHint.text
            request.refreshToken = MemberRepository.shared.getLocalRefreshToken()
            presenter?.passwordModify(request: request)
        }
    }
    
    private func setNavButton() {
    
        let font = UIFont.systemFont(ofSize: 14)
    
        let cancelBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(self.onTouchCancel))
        cancelBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "通用綠")
        
        setCustomRightBarButtonItem(barButtonItem: cancelBarButtonItem)
    }
}

extension PasswordModifyViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.view.endEditing(true)
    }
}

extension PasswordModifyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
            
        case originalPassword:
            newPassword.becomeFirstResponder()
            return true
            
        case newPassword:
            checkNewPassword.becomeFirstResponder()
            return true
            
        case checkNewPassword:
            passwordHint.becomeFirstResponder()
            return true
            
        case passwordHint:
            self.view.endEditing(true)
            onTouchConfirm(confirmButton)
            return true
            
        default:
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            
        case originalPassword:
            originalPassword.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            return true
            
        case newPassword:
            newPassword.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            return true
            
        case checkNewPassword:
            checkNewPassword.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            return true
            
        case passwordHint:
            passwordHint.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            hintLabel.isHidden = true
            return true
            
        default:
            return false
        }
    }
}

extension PasswordModifyViewController: PasswordModifyViewProtocol {
    
    func passwordModifySuccess() {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.setPasswordModifyToastText(text: "更改密碼成功")
        })
    }
    
    func passwordModifyFail(response: PasswordModifyResponse) {
        self.view.endEditing(true)
        self.toast(text: response.modifyPassowrd?.modifyMessage ?? "")
    }
}
