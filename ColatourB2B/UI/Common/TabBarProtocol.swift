//
//  TabBarProtocol.swift
//  colatour
//
//  Created by M7268 on 2019/4/1.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

protocol TabBarViewProtocol: NSObjectProtocol {
    func onBindNumberOfNoticeUnreadCount(numbers: Int)
}

protocol TabBarPresenterProtocol: BasePresenterProtocol {
    func getNumberOfNoticeUnreadCount()
}
