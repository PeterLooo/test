//
//  ApplePayManager.swift
//  colatour
//
//  Created by M6853 on 2019/1/7.
//  Copyright © 2019 Colatour. All rights reserved.
//
import PassKit
import UIKit
import TPDirect

extension DirectPayManager {
    func setUpPay(cardView: UIView, payButton: UIButton) {
        self.cardView = cardView
        self.payButton = payButton
        setUpDirectPay()
    }
    
    func startPay() {
        startDirectPay()
    }
}

protocol DirectPayManagerViewProtocol : NSObjectProtocol {
    func onGetDirectPayPrimeSuccess(primeToken: String, cardInfo: TPDCardInfo?)
    func onGetDirectPayPrimeFail(message: String)
    func onFormStatusError(message: String)
    func onFormStatus()
}

class DirectPayManager: NSObject {
    private weak var delegate: DirectPayManagerViewProtocol?
    private var tpdCard: TPDCard!
    private var tpdForm: TPDForm!
    private weak var cardView: UIView!
    private weak var payButton: UIButton!
    
    required init(delegate: DirectPayManagerViewProtocol) {
        self.delegate = delegate
    }
    
    private func setUpDirectPay(){
        tpdForm = TPDForm.setup(withContainer: cardView)
        tpdCard = TPDCard.setup(self.tpdForm)
        tpdForm.setErrorColor(UIColor.red)
        
        self.tpdForm.onFormUpdated { (status) in
            
            //TODO message提示字 一次要幾個 跟顯示什麼字 待確認
            var errorStringArray: [String] = []
            if (status.cardNumberStatus == FormStatus.error) {
                errorStringArray += ["卡號錯誤"]
            }
            if (status.expirationDateStatus == FormStatus.error) {
                errorStringArray += ["效期錯誤"]
            }
            if (status.cardNumberStatus == FormStatus.error) {
                errorStringArray += ["末三碼錯誤"]
            }
            
            if (status.isHasAnyError()) {
                let errorString = errorStringArray.joined(separator: "、")
                self.delegate?.onFormStatusError(message: errorString)
            }else {
                self.delegate?.onFormStatus()
            }
            
            self.payButton.isEnabled = status.isCanGetPrime()
            self.payButton.alpha = (status.isCanGetPrime()) ? 1.0 : 0.25
        }
        self.payButton.isEnabled = false
        self.payButton.alpha = 0.25
    }
    
    private func startDirectPay(){
        tpdCard.onSuccessCallback { (prime, cardInfo, cardIdentifier) in
            self.printLogGetPrimeResult(prime, cardInfo)
            
            self.delegate?.onGetDirectPayPrimeSuccess(primeToken: prime!, cardInfo: cardInfo)
            
            }.onFailureCallback { (status, message) in
                let result = "status : \(status),\n message : \(message)"
                self.printLog(result)
                
                self.delegate?.onGetDirectPayPrimeFail(message: result)
                
            }.getPrime()
    }
}

extension DirectPayManager {
    private func printLogGetPrimeResult(_ prime: String?, _ cardInfo: TPDCardInfo?) {
        #if DEBUG
        let result = "Prime : \(prime!),\n LastFour : \(cardInfo!.lastFour!),\n Bincode : \(cardInfo!.bincode!),\n Issuer : \(cardInfo!.issuer!),\n cardType : \(cardInfo!.cardType),\n funding : \(cardInfo!.cardType),\n country : \(cardInfo!.country!),\n countryCode : \(cardInfo!.countryCode!),\n level : \(cardInfo!.level!)"
        self.printLog(result)
        #endif
    }
    
    private func printLog(_ text: String){
        #if DEBUG
        print(text)
        #endif
    }
}
