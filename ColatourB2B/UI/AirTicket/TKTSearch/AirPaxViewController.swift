//
//  AirPaxViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/11.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

extension AirPaxViewController {
    
    func setTextWith(viewModel: AirPaxViewModel) {
        self.viewModel = viewModel
    }
}

class AirPaxViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var cardViewTop: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var aboveBackgroundView: UIView!
    @IBOutlet weak var adultCount: ChooseCountButton!
    @IBOutlet weak var childCount: ChooseCountButton!
    @IBOutlet weak var infanCount: ChooseCountButton!
    
    private var bottomButtonTitle: String?
    private var isFadeInBefore = false
    
    var onTouchBottomButton: ((_ lccTicketRequest: LccTicketRequest) ->())?
    var viewModel: AirPaxViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomButton.setTitle("確認", for: .normal)
        bottomButton.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠")!)
        adultCount.lowLimit = 1
        adultCount.setChooseCountButton(count: viewModel?.lccTicketRequest.adultCount ?? 0, allowSaleMark: true)
        childCount.setChooseCountButton(count: viewModel?.lccTicketRequest.childCount ?? 0, allowSaleMark: true)
        infanCount.setChooseCountButton(count: viewModel?.lccTicketRequest.infanCount ?? 0, allowSaleMark: true)
        adultCount.limitFlour = 9
        childCount.limitFlour = 9
        infanCount.limitFlour = 9
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fadeInBackgroundColor()
        layout()
    }
    
    @IBAction func onTouchBackgroundButton(_ sender: UIButton) {
        dismiss()
    }
    
    @IBAction func onTouchBottomButton(_ sender: UIButton) {
        
        viewModel?.lccTicketRequest.adultCount = adultCount.count
        viewModel?.lccTicketRequest.childCount = childCount.count
        viewModel?.lccTicketRequest.infanCount = infanCount.count
        dismiss()
        onTouchBottomButton?(viewModel?.lccTicketRequest ?? LccTicketRequest())
    }
    
    private func fadeInBackgroundColor(){
        if isFadeInBefore == false {
            isFadeInBefore = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = ColorHexUtil.hexColor(hex: "#6e6e6e").withAlphaComponent(0.5)
                self.aboveBackgroundView.backgroundColor = ColorHexUtil.hexColor(hex: "#6e6e6e").withAlphaComponent(0.5)
            }, completion:nil)
        }
    }
    
    private func fadeOutBackgroundColor(){
        if isFadeInBefore == true {
            isFadeInBefore = false
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = UIColor.clear
                self.aboveBackgroundView.backgroundColor = UIColor.clear
            }, completion:nil)
        }
    }
    
    private func layout() {
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
    
    private func dismiss() {
        fadeOutBackgroundColor()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AirPaxViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //Note: 往下拉關閉頁面
        let criticalVelocityY: CGFloat = -0.8
        let criticalContentY: CGFloat = 0
        if (velocity.y < criticalVelocityY) && (scrollView.contentOffset.y < criticalContentY) {
            dismiss()
        }
        
        //Note: 往上拉，停止時歸位，待確認兩邊都寫才有效果的原因
        if scrollView.contentOffset.y > 0  {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Note: 往上拉，停止時歸位，待確認兩邊都寫才有效果的原因
        if scrollView.contentOffset.y > 0  {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
