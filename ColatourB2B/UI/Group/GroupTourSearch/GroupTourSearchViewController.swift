//
//  GroupTourViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

enum GroupTourSearchTabType {
    case groupTour
    case keywordOrGroupNo
}

extension GroupTourSearchViewController {
    func setDefaultPage(_ tab: GroupTourSearchTabType){
        defaultPage = tab
    }
}

class GroupTourSearchViewController: BaseViewController {
    @IBOutlet weak var topPageScrollView: UIScrollView!
    @IBOutlet weak var topPageButtonView: UIView!
    @IBOutlet weak var topPageGroupTourButton: UIButton!
    @IBOutlet weak var topPageKeywordOrGroupdNoButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var groupTourPageView: UIView!
    @IBOutlet weak var keywrodOrGroupNoPageView: UIView!

    private var defaultPage: GroupTourSearchTabType = .groupTour
    private var isNeedShowDefaultPage = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavTitle(title: "搜尋")
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .notHidden)
        self.setTabBarType(tabBarType: .hidden)
        self.setIsNavShadowEnable(false)

        self.topPageScrollView.delegate = self
        scrollTopPageButtonBottomLine(percent: 0)
        switchPageButton(toPage: 0)

        self.viewReload()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNeedShowDefaultPage == false { return }
        isNeedShowDefaultPage = false
        switch defaultPage {
        case .groupTour:
            self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
        case .keywordOrGroupNo:
            self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
        }
    }
    
    override func adjustViewAppearance() {
        super.adjustViewAppearance()
        
        topPageButtonView.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4, color: UIColor.black.withAlphaComponent(0.8))
    }
    
    override func loadData() {
        super.loadData()

    }

    private func viewReload(){
        self.view.isUserInteractionEnabled = false

        //TODO setInit

        self.view.isUserInteractionEnabled = true
    }

}

//MARK: scroll top page 左邊滑到右邊，右邊滑到左邊
extension GroupTourSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != topPageScrollView { return }
        
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        //註解: 使用者滑動時，滑超過一半就應該算下一頁，所以是4.0，不是2.0
        let nowPage = (nowOffsetX < wholeWidth / 4.0) ? 0 : 1
        let percent = nowOffsetX / (wholeWidth / 2.0)
        scrollTopPageButtonBottomLine(percent: percent)
        switchPageButton(toPage: nowPage)
    }
}

extension GroupTourSearchViewController {
    @IBAction func onTouchGroupTour(_ sender: UIButton){
        self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
    }
    
    @IBAction func onTouchKeywordOrGroupNo(_ sender: UIButton){
        self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
    }
    
    private func scrollToPage(scrollView: UIScrollView, page: Int, animated: Bool) {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat){
        let maxOffset = UIScreen.main.bounds.width / 2.0
        let scrollOffset = maxOffset * percent
        self.pageButtonBottomLineLeading.constant = scrollOffset
    }
    
    private func switchPageButton(toPage: Int){
        switch toPage {
        case 0:
            enableButton(topPageGroupTourButton, isEnable: true)
            enableButton(topPageKeywordOrGroupdNoButton, isEnable: false)
        case 1:
            enableButton(topPageGroupTourButton, isEnable: false)
            enableButton(topPageKeywordOrGroupdNoButton, isEnable: true)
        default:
            ()
        }
    }
    
    private func enableButton(_ button: UIButton, isEnable: Bool){
        switch isEnable {
        case true :
            let color = UIColor.init(named: "通用綠")!
            button.tintColor = color
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.init(thickness: .semibold, size: 15.0)

        case false:
            let color = UIColor.init(named: "標題黑")!
            button.tintColor = color
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.init(thickness: .regular, size: 15.0)
        }
    }
}
