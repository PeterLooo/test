//
//  CalendarForTicketViewController.swift
//  colatour
//
//  Created by M6853 on 2018/5/7.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

extension CalendarForTicketViewController {
    //Note: 給push時，不用設定isDismissWhenTapConfirm
    func setVCNavBarItem(navMode: NavMode, isDismissWhenTapConfirm: Bool = true, navTitle: String) {
        self.navMode  = navMode
        self.isDismissWhenTapConfirm = isDismissWhenTapConfirm
        self.navTitle = navTitle
    }
}

class CalendarForTicketViewController: BaseViewController {
    @IBOutlet weak var calendarView: CalendarView!
    
    private var calendarAllAttribute: CalendarAllAttribute?
    private var start: Date?
    private var end: Date?
    private var single: Date?
    private weak var calendarDelegate: CalendarDataDestinationViewControllerProtocol?
    
    private var navMode : NavMode!
    private var navTitle: String = "選擇日期"
    private var navLeftType: NavLeftType = .defaultType
    private var isDismissWhenTapConfirm = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavMode(navMode: navMode, isDismissWhenTapConfirm: isDismissWhenTapConfirm)
        self.setNavBarItem(left: navLeftType, mid: .textTitle, right: .nothing)
        self.setNavTitle(title: navTitle)
        
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setTabBarType(tabBarType: .hidden)
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.calendarView.tableViewMonths.layoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navMode == .present {
            self.setIsPageSheetPresenting(isPresentVC: false)
            self.setBarAlpha(animate: true)
        }
    }
    
    override func loadData() {
        super.loadData()
        
        setUpCalendarView()
    }
    
    func setVCwith(delegate: CalendarDataDestinationViewControllerProtocol? = nil, calendarAllAttribute: CalendarAllAttribute){
        self.calendarDelegate = delegate
        self.calendarAllAttribute = calendarAllAttribute
    }
    
    private func setNavMode(navMode : NavMode, isDismissWhenTapConfirm: Bool ) {
        switch navMode {
        case .present:
            navLeftType = .close
        case .push:
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

extension CalendarForTicketViewController: CalendarViewControllerProtocol {
    func onTouchConfirm(selectedYearMonthDays: CalendarSelectedYearMonthDays) {
        self.calendarDelegate?.setSelectedDate(selectedYearMonthDaysToString: CalendarSelectedYearMonthDaysString(selectedYearMonthDays: selectedYearMonthDays))
        //Note: 點擊確認後，要刪除自己頁面
        switch navMode! {
        case .present:
            if ( isDismissWhenTapConfirm == true ){
                self.dismiss(animated: true, completion: nil)
            }
        case .push:
            ()
        }
    }

}
