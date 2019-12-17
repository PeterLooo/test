//
//  EncryptionUtils.m
//  ebs
//
//  Created by Rseq Lew on 2017/5/18.
//  Copyright © 2017年 Colatour. All rights reserved.
//

#import "EncryptionUtils.h"
#import "GTMBase64.h"

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>


@implementation EncryptionUtils


+(NSString *)DES3StringFromText:(NSString *)text{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vinitVec = (const void *) [@"" UTF8String];
    
    /*
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:@"YWajZGVma2hBamtsbe5vcHFyc3Raddaa" options:0];
     */
    
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:@"POaFgaVwa3hBDmsswe98sHEx93Ratwes" options:0];
    
    const void *vkey =  (const void *)([nsdataFromBase64String bytes]);
    //R9cIzmuBQUPDKWEnixShKpaJUMlGRfUmlGf1R51R5fs=
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCModeECB | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result;
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    result = [myData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

    return result;
}


@end
