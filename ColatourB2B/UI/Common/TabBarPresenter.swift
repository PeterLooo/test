//
//  TabBarPresenter.swift
//  colatour
//
//  Created by M7268 on 2019/4/1.
//  Copyright © 2019 Colatour. All rights reserved.
//

import RxSwift
import UIKit
import ObjectMapper

class TabBarPresenter: NSObject, TabBarPresenterProtocol {
    weak var delegate: TabBarViewProtocol?
    
    fileprivate var dispose = DisposeBag()
    
    convenience init(delegate: TabBarViewProtocol){
        self.init()
        self.delegate = delegate
    }

}
