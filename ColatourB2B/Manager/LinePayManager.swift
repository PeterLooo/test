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

extension LinePayManager {
    func getPrime() {
        startGetLinePayPrime()
    }
    
    func startPay(vc: UIViewController, paymentUrl: String){
        self.redirectToLinePay(vc: vc, paymentUrl: paymentUrl)
    }
}

protocol LinePayManagerViewProtocol : NSObjectProtocol {
    func onGetLinePayPrimeSuccess(primeToken: String)
    func onGetLinePayPrimeFail()
    func onPayLinePaySuccess()
}

class LinePayManager: NSObject {
    private weak var delegate: LinePayManagerViewProtocol?
    private var linePay: TPDLinePay!
    
    required init(delegate: LinePayManagerViewProtocol) {
        self.delegate = delegate
        linePay = TPDLinePay.setup(withReturnUrl: linePayHost)
    }
    
    private func startGetLinePayPrime(){
        if (TPDLinePay.isLinePayAvailable() == false) {
            TPDLinePay.installLineApp()
            return
        }

        linePay.onSuccessCallback { (prime) in
                self.delegate?.onGetLinePayPrimeSuccess(primeToken: prime!)
            
            }.onFailureCallback { (status, msg) in
                self.delegate?.onGetLinePayPrimeFail()
                
            }.getPrime()
    }
    
    private func redirectToLinePay(vc: UIViewController, paymentUrl: String){
        linePay.redirect(paymentUrl, with: vc, completion: { (result) in
            self.delegate?.onPayLinePaySuccess()
        })

    }
}

extension LinePayManager {
    private func printLog(_ text: String){
        #if DEBUG
        print(text)
        #endif
    }
}
