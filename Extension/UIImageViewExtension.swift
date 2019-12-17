//
//  UIImageViewExtension.swift
//  colatour
//
//  Created by M6853 on 2019/10/7.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(urlString: String?, isHiddenWhenError: Bool = true, defaultImage: UIImage? = nil){
        self.sd_setImage(with: URL.init(string: urlString ?? "")) { (image, error, cacheType, imageURL) in
            if error == nil {
                self.image = image
                if isHiddenWhenError { self.isHidden = false }
            }else{
                self.image = defaultImage
                if isHiddenWhenError { self.isHidden = true }
            }
        }
    }
    
    //Note: defaultImage，有空的時間在繼續實作
    func setImage(urlString: String?,
                  smallUrlString: String?,
                  isHiddenWhenError: Bool = true,
                  defaultImage: UIImage? = nil,
                  voidWithTheSameTimeSetImage: ((Bool) -> Void)? = nil,
                  completion: ((Bool) -> Void)? = nil,
                  smallPicCompletion: ((Bool) -> Void)? = nil,
                  isAnimate: Bool = false,
                  isSmallPicUrlEmtpyIgnore: Bool = true
                  ) {
        dowloadPic(urlString: smallUrlString,
                              isHiddenWhenError: false,
                              defaultImage: nil,
                              voidWithTheSameTimeSetImage: nil,
                              completion: { _ in
                                self.dowloadPic(urlString: urlString,
                                           isHiddenWhenError: isHiddenWhenError,
                                           defaultImage: defaultImage,
                                           voidWithTheSameTimeSetImage: voidWithTheSameTimeSetImage,
                                           completion: completion,
                                           isAnimate: isAnimate,
                                           isUrlEmtpyIgnore: false)
                                if let completion = smallPicCompletion {
                                    completion(true)
                                }
        }, isAnimate: isAnimate,
           isUrlEmtpyIgnore: isSmallPicUrlEmtpyIgnore)
    }
    
    private func dowloadPic(urlString: String?,
                    isHiddenWhenError: Bool = true,
                    defaultImage: UIImage? = nil,
                    voidWithTheSameTimeSetImage: ((Bool) -> Void)? = nil,
                    completion: ((Bool) -> Void)? = nil,
                    isAnimate: Bool = false,
                    isUrlEmtpyIgnore: Bool = true)
    {
        if isUrlEmtpyIgnore && urlString.isNilOrEmpty {
            if let completion = completion {
                completion(true)
            }
            return
        }
        SDWebImageManager.shared.loadImage(with: URL(string: urlString ?? ""), options: SDWebImageOptions.retryFailed, progress: nil, completed: { (image, data, error, cacheType, bool, imageURL) in
            if error == nil, let image = image {
                self.setImage(image: image, isAnimate: isAnimate, completion: completion, voidWithTheSameTimeSetImage: voidWithTheSameTimeSetImage)
                if isHiddenWhenError { self.isHidden = false }
            }else{
                self.setImage(image: image, isAnimate: isAnimate, completion: completion, voidWithTheSameTimeSetImage: voidWithTheSameTimeSetImage)
                if isHiddenWhenError { self.isHidden = true }
            }
        })
    }
    
    private func setImage(image: UIImage?, isAnimate: Bool, completion: ((Bool) -> Void)? = nil, voidWithTheSameTimeSetImage: ((Bool) -> Void)? = nil) {
        let duration = isAnimate ? 0.8 : 0
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.image = image
                            if let void = voidWithTheSameTimeSetImage {
                                void(true)
                            }
        },
                          completion: completion)
    }
}
