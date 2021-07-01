//
//  MailChageViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

extension MailChangeViewController {
    func setVC(viewModel: MailChangeViewModel) {
        self.viewModel = viewModel
    }
}

class MailChangeViewController: BaseViewControllerMVVM {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    private var viewModel: MailChangeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavTitle(title:"更正電子郵件信箱")
        setTabBarType(tabBarType: .hidden)
        tableView.register(UINib(nibName: "MailChangeCell", bundle: nil), forCellReuseIdentifier: "MailChangeCell")
        tableView.register(UINib(nibName: "EditingEmailCell", bundle: nil), forCellReuseIdentifier: "EditingEmailCell")
        tableView.register(UINib(nibName: "ConfirmKeyCell", bundle: nil), forCellReuseIdentifier: "ConfirmKeyCell")
        tableView.register(UINib(nibName: "ConfirmKeySuccessCell", bundle: nil), forCellReuseIdentifier: "ConfirmKeySuccessCell")
        bindViewModel()
    }
    
    @IBAction func bottomConfirmAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension MailChangeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.mailChangeCellViewModle == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel?.emailChangeType {
        case .changeEmail, .testEmail:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MailChangeCell", for: indexPath) as! MailChangeCell
            cell.setCell(viewModel: (viewModel?.mailChangeCellViewModle)!)
            return cell
            
        case .editingEmail:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditingEmailCell", for: indexPath) as! EditingEmailCell
            cell.setCell(viewModel: viewModel!.editingEmailCellViewModel!)
            return cell
        case .sendKey:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmKeyCell", for: indexPath) as! ConfirmKeyCell
            cell.setCell(viewModel: (viewModel?.confirmKeyCellViewModel)!)
            return cell
        case .testSuccess:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmKeySuccessCell", for: indexPath) as! ConfirmKeySuccessCell
            cell.setCell(viewModel: (viewModel?.confirmSuccessViewModel)!,
                         viewHight: view.frame.size.height - 
                            (self.navigationController?.navigationBar.frame.height ?? 0.0))
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MailChangeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension MailChangeViewController {
    
    @objc private func back(sender: UIBarButtonItem) {
        viewModel?.onTouchBack()
    }
    
    private func bindViewModel() {
        viewModel?.updateTableView = { [weak self] in
            switch self?.viewModel?.emailChangeType {
            case .editingEmail, .sendKey:
                self?.setNavBarItem(left: .custom, mid: .textTitle, right: .nothing)
                
                let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_back_purple"), style: .plain, target: self, action: #selector(self?.back(sender:)))
                newBackButton.imageInsets = UIEdgeInsets(top: 1, left: -7, bottom: 0, right: 0)
                self?.setCustomLeftBarButtonItem(barButtonItem: newBackButton)
                self?.setBarTypeLayoutImmediately()
            default :
                self?.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
                self?.setBarTypeLayoutImmediately()
            }
            self?.tableView.beginUpdates()
            self?.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            self?.tableView.endUpdates()
            
            self?.bottomView.isHidden = self?.viewModel?.emailChangeType != .testSuccess
        }
        
        viewModel?.nextTimeToEdit = { [weak self] in
            // 登入 B2B下次再修改Email api 好要確定一下流程
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
