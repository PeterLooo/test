//
//  PopTextViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/2/3.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol PopTextViewControllerProtocol: NSObjectProtocol {
    func onTouchBottomButton()
}

class PopTextViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var cardViewTop: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    
    private var text: String?
    private var navTitle: String?
    private var bottomButtonTitle: String?
    
    weak var delegate: PopTextViewControllerProtocol?
    
    private var isFadeInBefore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = text
        navItem.title = navTitle
        bottomButton.setTitle(bottomButtonTitle ?? "", for: .normal)
        
        textView.contentOffset.y = 0
        
        bottomButton.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠")!)
        setBarAlpha(alpha: 0, animate: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fadeInBackgroundColor()
        layout()
    }
    
    func setTextWith(text: String?, navTitle: String?, bottomButtonTitle: String?){
        self.text = text
        self.navTitle = navTitle
        self.bottomButtonTitle = bottomButtonTitle
    }
    
    @IBAction func onTouchClose(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTouchBackgroundButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTouchBottomButton(_ sender: UIButton) {
        delegate?.onTouchBottomButton()
    }
    
    private func fadeInBackgroundColor(){
        if isFadeInBefore == false {
            isFadeInBefore = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = ColorHexUtil.hexColor(hex: "#6e6e6e").withAlphaComponent(0.5)
            }, completion:nil)
        }
    }
    
    private func layout(){
        var textViewHeight = getTextViewHeight(textView: self.textView)
        textViewHeight = min(textViewHeight, screenHeight / 3)
        self.textViewHeight.constant = textViewHeight

        cardView.layoutIfNeeded()
        let safeAreaBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        cardViewTop.constant = screenHeight - statusBarHeight - cardView.frame.height - safeAreaBottom
    }
    
    private func getTextViewHeight(textView: UITextView) -> CGFloat {
        let width = textView.frame.width
        let countTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        countTextView.text = textView.text
        countTextView.font = textView.font
        countTextView.sizeToFit()
        return countTextView.frame.height
    }
}

extension PopTextViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        //Note: 往下拉關閉頁面
        let criticalVelocityY: CGFloat = -0.8
        let criticalContentY: CGFloat = 0
        if (velocity.y < criticalVelocityY) && (scrollView.contentOffset.y < criticalContentY) {
            self.dismiss(animated: true, completion: nil)
        }
        
        if scrollView == textView { return }
        
        //Note: 往上拉，停止時歸位，待確認兩邊都寫才有效果的原因
        if scrollView.contentOffset.y > 0  {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == textView { return }
        
        //Note: 往上拉，停止時歸位，待確認兩邊都寫才有效果的原因
        if scrollView.contentOffset.y > 0  {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
