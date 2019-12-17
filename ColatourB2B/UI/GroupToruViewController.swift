//
//  GroupToruViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import RxSwift
class GroupToruViewController: BaseViewController {
fileprivate var dispose = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        AccountRepository.shared.apiToken.subscribe(onSuccess: { (model) in
           print(model)
        }, onError: { (error) in
            print("error")
        }).disposed(by: dispose)
    }
    
}
