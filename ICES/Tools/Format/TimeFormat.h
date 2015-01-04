//
//  TimeFormat.h
//  ICES
//
//  Created by 徐宝桥 on 14/12/25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeFormat : NSObject

+ (NSString *)timeFromString:(NSString *)timeString;

+ (BOOL)isCurrentTimeBeforeTime:(NSString *)timeString;

@end
