//
//  CalendarDataToBackwardPageViewController.swift
//  colatour
//
//  Created by M6853 on 2018/5/7.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

enum NavMode {
    case present
    case push
}

extension CalendarDataToBackwardPageViewController {
    func setVCNavBarItem(navMode: NavMode) {
        self.navMode  = navMode
    }
}

class CalendarDataToBackwardPageViewController: BaseViewController {
    @IBOutlet weak var calendarView: CalendarView!
    
    private var calendarAllAttribute: CalendarAllAttribute?
    private var start: Date?
    private var end: Date?
    private var single: Date?
    private weak var calendarDelegate: CalendarDataDestinationViewControllerProtocol?
    
    private var navMode : NavMode!
    private var tite: String = "選擇日期"
    private var navLeftType: NavLeftType = .defaultType

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavMode(navMode: navMode)
        self.setNavBarItem(left: navLeftType, mid: .textTitle, right: .nothing)
        self.setNavTitle(title: tite)
        self.setTabBarType(tabBarType: .hidden)
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.calendarView.tableViewMonths.layoutSubviews()
    }
    
    override func loadData() {
        super.loadData()
        
        setUpCalendarView()
    }
    
    func setVCwith(delegate: CalendarDataDestinationViewControllerProtocol? = nil, calendarAllAttribute: CalendarAllAttribute){
        self.calendarDelegate = delegate
        self.calendarAllAttribute = calendarAllAttribute
    }
    
    private func setNavMode(navMode : NavMode) {
        switch navMode {
        case .present:
            tite = "查看價格"
            navLeftType = .close
        case .push:
            tite = "選擇日期"
            navLeftType = .defaultType
        }
    }
    
    private func setUpCalendarView(){
        self.loadingView.isHidden = false
        DispatchQueue.main.async {
            if let allAttribute = self.calendarAllAttribute {
                self.calendarView.initCalendarView(delegate: self, calendarAllAttribute: allAttribute)
            }
            self.loadingView.isHidden = true
        }
    }
    
}

extension CalendarDataToBackwardPageViewController: CalendarViewControllerProtocol {
    func onTouchConfirm(selectedYearMonthDays: CalendarSelectedYearMonthDays) {
        self.calendarDelegate?.setSelectedDate(selectedYearMonthDaysToString: CalendarSelectedYearMonthDaysString(selectedYearMonthDays: selectedYearMonthDays))
        //Note: 點擊確認後，要刪除自己頁面
        switch navMode! {
        case .present:
            self.dismiss(animated: true, completion: nil)
        case .push:
            for (key,value) in (self.navigationController?.viewControllers.enumerated())! {
                if value.restorationIdentifier == "CalendarDataToBackwardPageViewController"{
                    self.navigationController?.viewControllers.remove(at: key)
                }
            }
        }
    }

}
