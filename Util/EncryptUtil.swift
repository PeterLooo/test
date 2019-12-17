//
//  EncryptUtil.swift
//  colatour
//
//  Created by AppDemo on 2018/1/9.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class EncryptUtil: NSObject {
    
    static func encrypt(text:String) -> String{
        let keyStr = "POaFgaVwa3hBDmsswe98sHEx93Ratwes"
        print("----原密码---**\(text)**")
        
        /**
         3DES的加密过程 和 解密过程
         
         - parameter op : CCOperation： 加密还是解密
         CCOperation（kCCEncrypt）加密
         CCOperation（kCCDecrypt) 解密
         
         - parameter key: 专有的key,一个钥匙一般
         - parameter iv : 可选的初始化向量，可以为nil
         - returns      : 返回加密或解密的参数
         */
        
        let mi_string = threeDESEncryptOrDecrypt(text: text, op: CCOperation(kCCEncrypt), key: keyStr, iv: "")
        print("--加密--mi_string----***\(String(describing: mi_string))**")
        return String(describing: mi_string)
        
        //let ming_string = mi_string?.threeDESEncryptOrDecrypt(op: CCOperation(kCCDecrypt), key: keyStr, iv: "")
        //print("--解密--ming_string----***\(ming_string)**")
    
    }
    
    /**
     3DES的加密过程 和 解密过程
     
     - parameter op : CCOperation： 加密还是解密
     CCOperation（kCCEncrypt）加密
     CCOperation（kCCDecrypt) 解密
     
     - parameter key: 专有的key,一个钥匙一般
     - parameter iv : 可选的初始化向量，可以为nil
     - returns      : 返回加密或解密的参数
     */
    static func threeDESEncryptOrDecrypt(text:String, op: CCOperation,key: String,iv: String) -> String? {
        
        // Key
        let keyData: NSData = ((key as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?)!
        let keyBytes         = UnsafeMutableRawPointer(mutating: keyData.bytes)
        
        // 加密或解密的内容
        var data: NSData = NSData()
//        if op == CCOperation(kCCEncrypt) {
//            data  = text.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as NSData!
//        }
//        else {
//            data =  NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
//        }

        data  = (text.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as NSData?)!
        
        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeMutableRawPointer(mutating: data.bytes)
        
        // 返回数据
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)
        let cryptPointer = UnsafeMutableRawPointer(cryptData!.mutableBytes)
        let cryptLength  = size_t(cryptData!.length)
        
        //  可选 的初始化向量
        let viData :NSData = ((iv as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?)!
        let viDataBytes    = UnsafeMutableRawPointer(mutating: viData.bytes)
        
        // 特定的几个参数
        let keyLength              = size_t(kCCKeySize3DES)
        let operation: CCOperation = UInt32(op)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
        
        var numBytesCrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation, // 加密还是解密
            algoritm, // 算法类型
            options,  // 密码块的设置选项
            keyBytes, // 秘钥的字节
            keyLength, // 秘钥的长度
            viDataBytes, // 可选初始化向量的字节
            dataBytes, // 加解密内容的字节
            dataLength, // 加解密内容的长度
            cryptPointer, // output data buffer
            cryptLength,  // output data length available
            &numBytesCrypted) // real output data length
        
        
        print("cryptStatus:\(cryptStatus)")
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            
            cryptData!.length = Int(numBytesCrypted)
            if op == CCOperation(kCCEncrypt)  {
                let base64cryptString = cryptData?.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            }
            else {
                //   let base64cryptString = NSString(bytes: cryptPointer, length: cryptLength, encoding: NSUTF8StringEncoding) as? String  // 用这个会导致返回的JSON数据格式可能有问题，最好不用
                let base64cryptString = NSString(data: cryptData! as Data,  encoding: String.Encoding.utf8.rawValue) as String?
                return base64cryptString
            }
        } else {
            print("Error: \(cryptStatus)")
        }
        return nil
    }


}
