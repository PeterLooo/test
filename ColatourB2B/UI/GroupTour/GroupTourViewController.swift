//
//  GroupToruViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class GroupTourViewController: BaseViewController {

    private var presenter: GropeTourPresenter?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = GropeTourPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getApiToken()
    }
    
    private func getApiToken(){
        self.presenter?.getApiToken()
    }
    
    private func getVersionRule(){
        self.presenter?.getVersionRule()
    }
    
    override func onLoginSuccess(){
        self.getVersionRule()
    }
    
}

extension GroupTourViewController: GropeTourViewProtocol {
    func onBindApiTokenComplete() {
        getVersionRule()

    }
    
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?) {
        print(versionRule)
    }
    
}
