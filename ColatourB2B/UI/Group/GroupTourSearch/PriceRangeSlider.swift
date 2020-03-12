//
//  PriceRangeSlider.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/2/15.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import UIKit
protocol PriceRangeSliderPortocol: NSObjectProtocol {
    func sliderDown()
}
class PriceRangeSlider: UIControl {
    
    private var leftHandleLayer: CALayer!
    private var rightHandleLayer: CALayer!
    private var normalbackImageView: UIImageView!
    private var highlightedImageView: UIImageView!
    private var priceTextLabel: UILabel!
    
    private var barHeight: CGFloat = 3
    private var barWidth: CGFloat = 0
    private var handleWidth: CGFloat = 20
    private var handleHeight: CGFloat = 20
    
    private var insideMax: Int = 1000
    private var insideMin: Int = 0
    private var leftValue: Int = 00
    private var rightValue: Int = 0
    private var insideAccuracy: Int = 1
    
    private var previouslocation = CGPoint.zero
    
    private var isLeftSelected = false
    private var isRightSelected = false
    
    var valueChangeClosure: ((_ minValue: Int, _ maxValue: Int) -> ())?
    weak var delegate : PriceRangeSliderPortocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitValue()
        
        barWidth = frame.width - 2 * handleWidth
        normalbackImageView = UIImageView()
        normalbackImageView.backgroundColor = UIColor.init(red: 229, green: 229, blue: 229)
        normalbackImageView.frame = CGRect(x: handleWidth * 0.5, y: 0.5 * (frame.height - barHeight), width: frame.width - handleWidth, height: barHeight)
        addSubview(normalbackImageView)
        
        highlightedImageView = UIImageView()
        highlightedImageView.backgroundColor = UIColor.init(named: "通用綠")
        highlightedImageView.frame = CGRect(x: handleWidth * 0.5 , y: 0.5 * (frame.height - barHeight), width: frame.width - handleWidth, height: barHeight)
        addSubview(highlightedImageView)
        
        leftHandleLayer = createHandleLayer()
        leftHandleLayer.frame = CGRect(x:0 ,y: 0.3 * (frame.height - handleHeight), width:  handleWidth, height: handleHeight)
        leftHandleLayer.shadowColor = UIColor.lightGray.cgColor
        leftHandleLayer.shadowOffset = CGSize(width: 0, height: 1)
        leftHandleLayer.shadowOpacity = 1.0
        leftHandleLayer.shadowRadius = 2
        layer.addSublayer(leftHandleLayer)
        
        rightHandleLayer = createHandleLayer()
        rightHandleLayer.frame = CGRect(x:frame.width - handleWidth,y:  leftHandleLayer.frame.minY, width:handleWidth, height: handleHeight)
        rightHandleLayer.shadowColor = UIColor.lightGray.cgColor
        rightHandleLayer.shadowOffset = CGSize(width: 0, height: 1)
        rightHandleLayer.shadowOpacity = 1.0
        rightHandleLayer.shadowRadius = 2
        layer.addSublayer(rightHandleLayer)
        
        let kTextWidth: CGFloat = barWidth
        let kTextHeight: CGFloat = 20
        priceTextLabel = UILabel(frame:  CGRect(x:leftHandleLayer.frame.minX , y: leftHandleLayer.frame.minY + 30, width: kTextWidth, height: kTextHeight))
        priceTextLabel.text = "\(insideMin)"
        priceTextLabel.textColor = UIColor.init(named: "標題黑")
        priceTextLabel.font = UIFont(name: "PingFangTC-Regular", size: 14)
        priceTextLabel.textAlignment = .left
        addSubview(priceTextLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRange(minRange: Int, maxRange: Int, accuracy: Int){
        insideMax = maxRange
        insideMin = minRange
        insideAccuracy = accuracy
        setInitValue()
        setLabelText()
    }
    
    func setCurrentValue(left: Int, right: Int){
        if left > right{
            return
        }
        leftValue = max(insideMin,left)
        leftValue = min(insideMax,leftValue)
        
        rightValue = max(right,insideMin)
        rightValue = min(rightValue,insideMax)
        
        let range = insideMax - insideMin
        var priceLeft = CGFloat(leftValue - insideMin)/CGFloat(range)
        var paiceRight = CGFloat(rightValue - insideMin)/CGFloat(range)
        priceLeft = priceLeft.isNaN == true ? 0:priceLeft
        paiceRight = paiceRight.isNaN == true ? 1:paiceRight
        
        leftHandleLayer.frame = CGRect(x: priceLeft * barWidth, y: 0.5 * (frame.height - handleHeight), width: handleWidth, height: handleHeight)
        rightHandleLayer.frame = CGRect(x:paiceRight * barWidth + leftHandleLayer.frame.width,y:  leftHandleLayer.frame.minY, width:handleWidth, height: handleHeight)
        setLabelText()
        updateHighlightedBar()
    }
    
    func getMaxPrice() -> Int {
        return rightValue/insideAccuracy * insideAccuracy
    }
    
    func getMinPrice() -> Int {
        return leftValue/insideAccuracy * insideAccuracy
    }
    
    private func setInitValue(){
        leftValue = insideMin
        rightValue = insideMax
    }
    
    private func updateHighlightedBar(){
        highlightedImageView.frame = CGRect(x: leftHandleLayer.frame.maxX - 0.5 * handleWidth,y: 0.5 * (frame.height - barHeight), width: rightHandleLayer.frame.minX - leftHandleLayer.frame.maxX + handleWidth, height: barHeight)
        setLabelText()
        valueChangeClosure?(leftValue/insideAccuracy * insideAccuracy,rightValue/insideAccuracy * insideAccuracy)
    }
    
    private func setLabelText(){
        let startPrice = FormatUtil.priceFormat(price: leftValue/insideAccuracy * insideAccuracy)
        let endPrice = FormatUtil.priceFormat(price: rightValue/insideAccuracy * insideAccuracy)
        
        priceTextLabel.text = "\(startPrice) - \(endPrice)"
    }
    
    private func createHandleLayer() -> CALayer{
        let layer = CALayer()
        layer.cornerRadius = handleWidth * 0.5
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }
    
}

extension PriceRangeSlider {
    private func setRightHitRect(rect: CGRect) -> CGRect{
        let offset:CGFloat = 20
        return CGRect(x:rect.minX, y: rect.minY - offset, width: rect.width + offset, height: 2 * offset + rect.height)
    }
    
    private func setLeftHitRect(rect: CGRect) -> CGRect{
        let offset:CGFloat = 20
        return CGRect(x:rect.minX - offset, y: rect.minY - offset, width: rect.width + offset, height: 2 * offset + rect.height)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if insideMin == insideMax { return false}
        previouslocation = touch.location(in: self)
        isLeftSelected = setLeftHitRect(rect: leftHandleLayer.frame).contains(previouslocation)
        isRightSelected = setRightHitRect(rect: rightHandleLayer.frame).contains(previouslocation)
        return isLeftSelected || isRightSelected
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = (location.x - previouslocation.x)
        previouslocation = location
        
        if isLeftSelected{
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            leftHandleLayer.frame.origin.x = max(leftHandleLayer.frame.origin.x + deltaLocation, normalbackImageView.frame.minX + 0.5 * handleWidth - leftHandleLayer.frame.width)
            leftHandleLayer.frame.origin.x = min(leftHandleLayer.frame.origin.x, rightHandleLayer.frame.origin.x - leftHandleLayer.frame.width)
            leftValue = Int(leftHandleLayer.frame.origin.x/barWidth * CGFloat(insideMax - insideMin)) + insideMin
            updateHighlightedBar()
            CATransaction.commit()
            
        }else if isRightSelected{
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            rightHandleLayer.frame.origin.x = min(rightHandleLayer.frame.origin.x + deltaLocation,frame.width - rightHandleLayer.frame.width)
            rightHandleLayer.frame.origin.x = max(rightHandleLayer.frame.origin.x,leftHandleLayer.frame.origin.x + leftHandleLayer.frame.width)
            rightValue = Int((rightHandleLayer.frame.origin.x - leftHandleLayer.frame.width)/barWidth * CGFloat(insideMax - insideMin)) + insideMin
            updateHighlightedBar()
            CATransaction.commit()
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isLeftSelected = false
        isRightSelected = false
        self.delegate?.sliderDown()
    }
}

