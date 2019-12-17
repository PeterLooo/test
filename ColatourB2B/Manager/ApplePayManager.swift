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

extension ApplePayManager {
    func setItem(item: TPDPaymentItem){
        self.item = item
    }
    
    func getPrime(){
        setUpApplePay()
        if (checkIsApplePayAvailable().isAvaliable == false) {
            //TODO alert?
            self.delegate?.onGetApplePayPrimeFail(alertMsg: checkIsApplePayAvailable().alertMsg!)
            return
        }
        startApplePay()
    }
    
    func showPaymentResult(result: Bool){
        let paymentResult = result
        applePay.showPaymentResult(paymentResult)
    }
}

protocol ApplePayManagerViewProtocol : NSObjectProtocol {
    func onGetApplePayPrimeSuccess(primeToken: String)
    func onGetApplePayPrimeFail(alertMsg: String)
}

class ApplePayManager: NSObject {
    var applePay: TPDApplePay!
    var merchant: TPDMerchant!
    var consumer: TPDConsumer!
    var cart: TPDCart!
    private weak var delegate : ApplePayManagerViewProtocol!
    private var item: TPDPaymentItem?
    private let alertMsgWhenCardNotSupport = "您的手機未綁定信用卡至Apple Pay"
    private let alertMsgWhenPhoneNotSupport = "您的手機不支援Apple Pay"
    
    required init(delegate : ApplePayManagerViewProtocol) {
        self.delegate = delegate
    }
    
    private func setUpApplePay(){
        setUpMerchant()
        setUpConsumer()
        setUpCart()
    }
    
    private func setUpMerchant(){
        merchant = TPDMerchant()
        //TODO merchantName API 接上
        merchant.merchantName = "Colatour"
        merchant.merchantCapability = PKMerchantCapability.capability3DS
        //Note: applePayMerchantIdentifier 給錯，會跳delegate start cancel finish
        //TODO 接上 正式測試demo
        merchant.applePayMerchantIdentifier = applePayMerchantIdentifier
        merchant.countryCode = "TW"
        merchant.currencyCode = "TWD"
        //Note: iOS10.1以上開始支援JCB
        if #available(iOS 10.1, *) {
            merchant.supportedNetworks = [.amex, .visa, .masterCard, .JCB]
        } else {
            merchant.supportedNetworks = [.amex, .visa, .masterCard]
        }
    }
    
    private func setUpConsumer(){
        consumer = TPDConsumer()
        //Note: ShippingAddress手機沒有設置時，手機會跳提示
        //Note: BillingAddress手機沒有設置時，手機不跳提示
        consumer.requiredShippingAddressFields = []
        consumer.requiredBillingAddressFields = []
    }
    
    private func setUpCart(){
        //Note: item = TPDPaymentItem(itemName: "某商品", withAmount: 999999999) applePay會不出現
        cart = TPDCart()
        cart.add(item)
    }
    
    //Note: 若回傳false，一定要給alertMsg
    private func checkIsApplePayAvailable() -> (isAvaliable: Bool, alertMsg: String?) {
        //Note: 檢查卡片是否支援Apple Pay
        if !TPDApplePay.canMakePayments(usingNetworks: self.merchant.supportedNetworks) {
            return (false, alertMsgWhenCardNotSupport)
        }
        //Note: 檢查機台是否支援Apple Pay
        if !TPDApplePay.canMakePayments(){
            return (false, alertMsgWhenPhoneNotSupport)
        }
        
        return (true, nil)
    }
    
    private func startApplePay(){
        applePay = TPDApplePay.setupWthMerchant(merchant, with: consumer, with: cart, withDelegate: self)
        applePay.startPayment()
    }
}

extension ApplePayManager : TPDApplePayDelegate {
    // Send To The Delegate After Apple Pay Payment's Form Is Shown.
    func tpdApplePayDidStartPayment(_ applePay: TPDApplePay!) {
        printLog("===Apple Pay On Start===")
    }
    
    //Note: showPaymentResult(result: true)之後會到這
    // Send To The Delegate After Apple Pay Payment Processing Succeeds.
    func tpdApplePay(_ applePay: TPDApplePay!, didSuccessPayment result: TPDTransactionResult!) {
        printLog("===Apple Pay Did Success===")
    }
    
    //Note: showPaymentResult(result: false)之後會到這
    // Send To The Delegate After Apple Pay Payment Processing Fails.
    func tpdApplePay(_ applePay: TPDApplePay!, didFailurePayment result: TPDTransactionResult!) {
        //TODO 顯示錯誤之類的
        printLog("===Apple Pay Did Failure ===")
    }
    
    // Send To The Delegate After User Cancels The Payment.
    func tpdApplePayDidCancelPayment(_ applePay: TPDApplePay!) {
        printLog("======> Apple Pay Did Cancel")
    }
    
    // Send To The Delegate After Apple Pay Payment's Form Disappeared.
    func tpdApplePayDidFinishPayment(_ applePay: TPDApplePay!) {
        printLog("======> Apple Pay Did Finish")
    }
    
    // Send To The Delegate After User Selects A Shipping Method.
    // Set shippingMethods ==> TPDMerchant.shippingMethods.
    func tpdApplePay(_ applePay: TPDApplePay!, didSelect shippingMethod: PKShippingMethod!) {
        printLog("======> didSelectShippingMethod: ")
    }
    
    // Send To The Delegate After User Selects A Payment Method.
    // You Can Change The PaymentItem Or Discount Here.
    func tpdApplePay(_ applePay: TPDApplePay!, didSelect paymentMethod: PKPaymentMethod!, cart: TPDCart!) -> TPDCart! {
        printLog("======> didSelectPaymentMethod: ");
        //Note: 每次開apple Pay 可能會累加 要小心
        return self.cart;
    }
    
    // Send To The Delegate After User Authorizes The Payment.
    // You Can Check Shipping Contact Here, Return YES If Authorized.
    func tpdApplePay(_ applePay: TPDApplePay!, canAuthorizePaymentWithShippingContact shippingContact: PKContact!) -> Bool {
        printLog("======> canAuthorizePaymentWithShippingContact ")
        return true;
    }
    
    // Send To The Delegate After Receive Prime.
    func tpdApplePay(_ applePay: TPDApplePay!, didReceivePrime prime: String!) {
        
        // 1. Send Your Prime To Your Server, And Handle Payment With Result
        printLog("======> didReceivePrime");
        printLog("Prime : \(prime!)");
        
        // 2. If Payment Success, applePay.
        //Note : getPrime丟api處理
        self.delegate?.onGetApplePayPrimeSuccess(primeToken: prime)
    }
}

extension ApplePayManager {
    private func printLog(_ text: String){
        #if DEBUG
        print(text)
        #endif
    }
}
