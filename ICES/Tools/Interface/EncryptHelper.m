//
//  EncryptHelper.m
//  ICES
//
//  Created by 徐宝桥 on 14/12/12.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "EncryptHelper.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation EncryptHelper

+ (NSString *)MD5_encryptWithString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

@end
