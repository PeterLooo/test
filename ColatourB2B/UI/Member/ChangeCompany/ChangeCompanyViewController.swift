//
//  ChangeCompanyViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class ChangeCompanyViewController: BaseViewControllerMVVM {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: ChangeCompanyViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "改任職旅行社")
        self.setTabBarType(tabBarType: .hidden)
        
        tableView.register(UINib(nibName: "ChangeCompanyCell", bundle: nil), forCellReuseIdentifier: "ChangeCompanyCell")
        setKeyboardShow()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func onTouchConfirm(_ sender: Any) {
        viewModel?.onTouchConfirm()
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
        return viewModel?.changeModel == nil ? 0:1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeCompanyCell") as! ChangeCompanyCell
        cell.setCell(viewModel: (viewModel?.changeModel)!)
        return cell
    }
}

extension ChangeCompanyViewController: UITableViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view.endEditing(true)
    }
}

extension ChangeCompanyViewController {
    private func bindViewModel(){
        viewModel = ChangeCompanyViewModel()
        viewModel?.getChangeCompanyInfo()
        viewModel?.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setKeyboardShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
