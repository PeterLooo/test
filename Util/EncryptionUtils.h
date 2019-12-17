//
//  EncryptionUtils.h
//  ebs
//
//  Created by Rseq Lew on 2017/5/18.
//  Copyright © 2017年 Colatour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionUtils: NSObject

+(NSString *)DES3StringFromText:(NSString *)text;

@end
