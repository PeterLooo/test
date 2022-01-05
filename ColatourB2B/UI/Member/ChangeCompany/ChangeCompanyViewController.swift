//
//  ChangeCompanyViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit
extension ChangeCompanyViewController {
    func setView(editType: MemberEdit, loginResponse: LoginResponse?) {
        self.editType = editType
        viewModel = ChangeCompanyViewModel(loginResponse: loginResponse)
    }
}
class ChangeCompanyViewController: BaseViewControllerMVVM {

    enum MemberEdit {
        case company
        case memberInfo
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    private var viewModel: ChangeCompanyViewModel?
    private var editType: MemberEdit = .company
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setTabBarType(tabBarType: .hidden)
        tableView.register(UINib(nibName: "ChangeCompanyCell", bundle: nil), forCellReuseIdentifier: "ChangeCompanyCell")
        tableView.register(UINib(nibName: "ChangeMemberInfoCell", bundle: nil), forCellReuseIdentifier: "ChangeMemberInfoCell")
        tableView.register(UINib(nibName: "EmployeeDisableCell", bundle: nil), forCellReuseIdentifier: "EmployeeDisableCell")
        setKeyboardShow()
        bindViewModel()
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        
        if isEmployee == true {
            tableView.reloadData()
            bottomView.isHidden = true
            return
        }
        switch editType {
        case .company:
            viewModel?.getChangeCompanyInfo()
        case .memberInfo:
            viewModel?.changeMemberInfoInit()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func onTouchConfirm(_ sender: Any) {
        viewModel?.onTouchConfirm(editMode: editType)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.05, animations: {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.cgRectValue.height , right: 0)
            }
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.05, animations: {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
}

extension ChangeCompanyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEmployee == true { return 1}
        switch editType {
        case .company:
            return viewModel?.changeCompanyModel == nil ? 0:1
        case .memberInfo:
            return viewModel?.changeMemberInfo == nil ? 0:1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEmployee == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDisableCell") as! EmployeeDisableCell
            return cell
        }
        switch editType {
        case .company:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeCompanyCell") as! ChangeCompanyCell
            cell.setCell(viewModel: (viewModel?.changeCompanyModel)!)
            return cell
        case .memberInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeMemberInfoCell") as! ChangeMemberInfoCell
            cell.setCell(viewModel: (viewModel?.changeMemberInfo)!)
            return cell
        }
    }
}

extension ChangeCompanyViewController: UITableViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view.endEditing(true)
    }
}

extension ChangeCompanyViewController {
    private func bindViewModel(){
        
        self.bindToBaseViewModel(viewModel: viewModel!)
        viewModel?.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel?.setMemberErrorInfo = { [weak self] errorList in
            if self?.tableView.subviews.first is ChangeMemberInfoCell {
                (self?.tableView.subviews.first as! ChangeMemberInfoCell).setErrorInfo(errorList: errorList)
            }
            self?.tableView.reloadData()
        }
        
        viewModel?.toastInfo = { [weak self] text in
            self?.toast(text: text)
        }
        
        viewModel?.changeCompanySuccessfully = { [weak self] in
            let vc = self?.getVC(st: "ChangeCompany", vc: "ChangeCompanySuccess") as! ChangeCompanySuccessViewController
            vc.onTouchDoneClosure = { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            }
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self?.navigationController?.present(nav, animated: true)
        }
        
        viewModel?.emailConfirm = {[weak self] in
            let vc = self?.getVC(st: "Login", vc: "MailChangeViewController") as! MailChangeViewController
            let viewModel = MailChangeViewModel.init(type: .sendKey, loginResponse: nil)
            
            vc.setVC(viewModel: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setTitle() {
        switch editType {
        case .memberInfo:
            self.setNavTitle(title: "更改會員資料")
        case .company:
            self.setNavTitle(title: "改任職旅行社")
        }
    }
    
    private func setKeyboardShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
